% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

classdef spTensor
    properties
        subs
        vals
        dims
    end
    
    methods
        function [t] = spTensor(subs, vals, sz)
            %[t] = spTensor(subs, vals, sz)
            
            if nargin == 1 
                if issparse(subs) %convert from sparse matrix
                    [ii jj vv] = find(subs);
                    t.subs = int32([ii jj]);
                    t.vals = vv;
                    t.dims = size(subs);
                    return;
                elseif isstruct(subs)
                    t.subs = int32(subs.subs);
                    t.vals = double(subs.vals);
                    t.dims = double(subs.size);
                else
                    error('can only convert from sparse matrix or spTensor struct');
                end
            else
                if nargin < 3 %if size is not available
                    sz = max(subs);
                else
                    assert(all(max(subs,[],1) <= sz), 'index out of range');
                end

                assert(size(subs,1) == numel(vals));
                t.subs = int32(subs);
                t.vals = double(vals(:));
                t.dims = double(sz);
            end
        end
        
        function [ varargout ] = size(self, dim)
            if nargin > 1
                if nargout == 0
                    fprintf('size = ');disp(self.dims(dim));
                else
                    varargout{1} = self.dims(dim);
                end
            else
                if nargout == 0
                    fprintf('size = ');disp(self.dims);
                elseif nargout == 1
                    varargout{1} = self.dims;
                else
                    assert(nargout <= ndims(self));
                    for ind = 1:nargout
                        varargout{ind} = self.dims(ind);
                    end
                end
            end
        end
        
        function [self] = AdjustSize(self)
            self.dims = double(max(self.subs,[],1));
        end
        
        function [ r ] = ndims( self )
            r = size(self.subs, 2);
        end
        
        function [r] = nnz(self)
            r = length(self.vals);
        end
        
        function [r] = numel(self)
            r = prod(self.dims);
        end
        
        function [r] = idx(self, dim)
            if nargin < 2
                r = self.subs;
            else
                r = self.subs(:, dim);
            end
        end
        
        function [mat] = ToMat(self)
            if ndims(self) == 1
                mat = sparse(double(self.subs), ones(length(self.subs)), self.vals, ...
                        self.dims(1), 1);
            else
                mat = sparse(double(self.subs(:,1)), double(self.subs(:,2)), self.vals, ...
                        self.dims(1), self.dims(2));
            end
        end
        
        function [mats] = ToMats(self)
            mats = cell(1, size(self, 3));
            idx = accumarray(self.subs(:,3), 1:nnz(self), [size(self,3) 1], @(x){x});
            ss = double(self.subs);
            vv = double(self.vals);
            for ind = 1:length(mat)
                ii = idx{ind};
                mats{ind} = sparse(ss(ii,1), ss(ii,2), vv(ii), ...
                     self.dims(1), self.dims(2));
            end
        end
        
        function [r] = Reduce(self, dims)
            r = spTensor(self.subs(:,dims), self.vals, self.size(dims));
        end
        
        function [r uidx] = Clean(self)
            filter = min(self.subs, [], 2) > 0;
            r = spTensor(self.subs(filter, :), self.vals(filter), self.dims);

            nd = ndims(self);
            uidx = cell(1, nd);
            for ind = 1:nd
                uidx{ind} = unique(r.subs(:,ind));
                r.subs(:,ind) = EncodeInt(r.subs(:,ind), uidx{ind});
                r.dims(ind) = length(uidx{ind});
            end
        end
        
        function r = ToStruct(self)
            r = struct('subs',self.subs, 'vals',self.vals, 'size',self.dims);
        end
    end
end
