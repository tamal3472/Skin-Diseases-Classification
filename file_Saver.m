
ComputeAll = 1;%To segment just one image (0) or all images (1) 
DirImages = 'E:\Data Thesis processing\solar lentigo\jpg\'; %Directory including input image(s)
DirResults ='E:\Data Thesis processing\solar lentigo\jpg\renamed\'; %Directory including output mask(s)
NumImm=1; %The NumImm-th image in the directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Adjustable parameters:
MaxDim=1024; %Max width of input images (otherwise, they are scaled)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fmt='*.jpeg'; %image format
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
    I1=imread(ImgName,'jpeg');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %1) Reduces image size (-->I2)
    [r, c]=size(I1);
    if (r ~=1024 && c~=768)
      I2 = imresize(I1,[768 1024]);
    
    else
       I2=I1;
    end
    
  
    if (MustSave)
        lIN=length(ImgName);
        imwrite(I2, strcat(DirResults, strcat(ImgName(lIN-15:lIN-4)),'_ISIC0000.jpg'));
    end
    if (ComputeAll)
        clear I1 I2 I3 maskROI Dark Hair Highlights BWnoCH BW FinalBin
    end
end
toc
