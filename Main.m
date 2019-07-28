
ComputeAll = 1;%To segment just one image (0) or all images (1) 
DirImages ='E:\Data Thesis processing\solar lentigo\filtered\'; %Directory including input image(s)
DirResults ='E:\Data Thesis processing\solar lentigo\segmented\'; %Directory including output mask(s)
NumImm=1; %The NumImm-th image in the directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Adjustable parameters:
MaxDim=1024; %Max width of input images (otherwise, they are scaled)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fmt='*.jpg'; %image format
if (ComputeAll)
    show       = 0; %Do not show results
    MustSave   = 1; %Save results on file
else
    show       = 1; %Show results
    MustSave   = 0; %Do not save results on file
end
%Creates the output directory, if necessary
if (MustSave && not(exist(DirResults,'dir')))
    mkdir(DirResults);
end

ImgName = strcat(DirImages,Fmt);
ImgList = dir(ImgName);
NumberOfImages = size(ImgList,1)
if (ComputeAll)
    ninit = 1; nend = NumberOfImages; 
else
    ninit = NumImm; nend = NumImm; 
end
tic
for number = ninit:nend
  ImgName = strcat(DirImages,cat(1,ImgList(number).name));
    fprintf('N. %d: %s\n',number,cat(1,ImgList(number).name));    
    I1=imread(ImgName,'jpg');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %1) Reduces image size (-->I2)
    if (size(I1,2)>MaxDim)
       I2 = imresize(I1,MaxDim/size(I1,2));
    else
       I2 = I1;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %2) Computes ROI (-->I3, Border, Dark, Hair, Highlights)
    [I3, Border, Dark, Highlights, Hair] = Step1_ExtractInfo(I2, show); 
%
%   If you want to avoid Step1, instead of calling Step1_ExtractInfo, just set:
%
%   I3=I2; Border=[0 0 0 0]; Dark=I3(:,:,1)<0; Highlights=Dark; Hair=Dark;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %3) Chooses the right segmentation band and segments (--> BWinit)
    BWinit = Step2_SegmentAndSelect(I3, Dark, Hair, Highlights, show);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %4) Post-processes BWinit (--> BW)
    BW = Step3_PostProcess(BWinit, 0); %show); %Useless; shown at the end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %6) Brings the resulting mask back to original dimensions and Shows/Saves results
    [FinalBin] = BackToOriginal(BW, I1, zeros(size(I2,1),size(I2,2)), Border);
    I2(find(~FinalBin)+[0 numel(FinalBin)*[1 2]]) = NaN;
    if (show)
        [FinalBWnoCH] = BackToOriginal(BWinit, I1, zeros(size(I2,1),size(I2,2)), Border);
        maskROI       = imcomplement(Dark | Hair | Highlights);
        figure('Name','Step 3: Final result'); 
        subplot(2,2,1); imshow(I1);          title('input image');
        subplot(2,2,2); imshow(maskROI);     title('ROI mask');
        subplot(2,2,3); imshow(FinalBWnoCH); title('Initial segmentation');
        subplot(2,2,4); imshow(I2);    title('Final segmentation');
    end
    if (MustSave)
        lIN=length(ImgName);
        imwrite(I2, strcat(DirResults, strcat(ImgName(lIN-5:lIN-1)),'_segmentation.png'));
    end
    if (ComputeAll)
        clear I1 I2 I3 maskROI Dark Hair Highlights BWnoCH BW FinalBin
    end
end
toc
