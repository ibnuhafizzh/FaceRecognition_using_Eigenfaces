function [acc,mindist,recog] = face_recognition(w, labels, w2, labels2,N)
    %% Initializations
    v=w; % v contains the training set. 
    % N = Number of eigenface components used for each image
    %% Subtracting the mean from v
    O=single((ones(1,size(v,2)))); 
    m=single((mean(v,2))); % m is the mean of all images.
    vzm=v-(m*O); % vzm is v with the mean removed. 
    
    %% Calculating eigenvectors of the correlation matrix
    L=single(vzm)'*single(vzm);
    [V,D]=eig(L);
    V=single(vzm)*V;
    % Pick the eigenvectors corresponding to the N largest eigenvalues. 
    V=V(:,end:-1:end-(N-1));
    %% Calculating the signature weight for each image
    cv=zeros(size(v,2),N);
    for i=1:size(v,2)
        % Each row in cv is the signature for one image.
        cv(i,:)=single(vzm(:,i))'*V;
    end
    %% Recognition 
    %  run algorithm and see if can correctly recognize the face. 
    recog = [];
    dist = [];
    mindist = [];
    
    for j=1:size(w2,2)
        r=w2(:,j);                        % r contains a test image
        p=r-m;                            % Subtract the mean
        s=single(p)'*V;
        z=[];
        for i=1:size(v,2)
            z=[z,norm(cv(i,:)-s,2)];
        end
        dist = [dist;z];
        [a,i]=min(z);
        mindist = [mindist,a];
        recog = [recog,labels(i)];
    end
    
    for j=1:length(recog)
        % result=1 if recog match labels2, 0 otherwise
        result(j) = isequal(recog(j), labels2(j)); 
    end
    
    acc = sum(result)./length(result); %accuracy
end







