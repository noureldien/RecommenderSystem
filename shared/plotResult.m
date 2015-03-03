function plotResult(confusionEstm, rmseEstm, ameEstm, confusionRand, rmseRand, ameRand)
% plot the given result
% INPUT:
%     confusionEstm :
%     rmseEstm      :
%     ameEstm       :
%     confusionRand :
%     rmseRand      :
%     ameRand       :

% plot the result
figure(1); clf;
subplot(2,1,1);
imshow(confusionEstm, 'InitialMagnification', 1000);
title(strcat('Prediction: RMSE: ', num2str(rmseEstm), ', Error Rate:', num2str(ameEstm)));
colormap(jet);
colorbar;
subplot(2,1,2);
imshow(confusionRand, 'InitialMagnification', 1000);
title(strcat('Random: RMSE: ', num2str(rmseRand), ', Error Rate:', num2str(ameRand)));
colormap(jet);
colorbar;

end

