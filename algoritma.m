clear all;
clc;
sehirsayisi=31;
isciarisayisi=15;
gozcuarisayisi=15;
besinsayisi=50;
limit=100;
ilmesafe=xlsread('ilcemesafe1.xls');
eniyicozumdegeri=1000000;
besin=besinmatrisi(besinsayisi,sehirsayisi);
denemesayisi=zeros(size(besin(:,1)));
for i=1:besinsayisi    
    cozumdegeri(i)=amacfonksiyonu(besin(i,: ) ,ilmesafe,sehirsayisi)
    if eniyicozumdegeri>cozumdegeri(i)        
        eniyicozumdegeri=cozumdegeri(i);
        eniyicozum=besin(i,:);        
    end    
end
for iterasyon=1:1000
    % ÝÞÇÝ arý safhasý baþlar
    for i=1:isciarisayisi
        
        degisecekbesinno=randi([1 besinsayisi]);
        r=rand(1);
        
        indisl=randi([1 sehirsayisi]);
        indis2=randi([1 sehirsayisi]);
        while indisl==indis2
            
            indis2=randi([1 sehirsayisi]);
            
        end
        
        if r<1/3
            
            yenibesin=yerdegistir(besin(degisecekbesinno,:),indisl,indis2);
        elseif r<2/3
            
            yenibesin=solakaydir(besin(degisecekbesinno,:),indisl,indis2);
            
        else
            
            yenibesin=diziyiterscevir(besin(degisecekbesinno,:),indisl,indis2);
        end
        
        yenicozumdegeri=amacfonksiyonu(yenibesin,ilmesafe,sehirsayisi);
        if yenicozumdegeri<cozumdegeri(degisecekbesinno)
            
            cozumdegeri(degisecekbesinno)=yenicozumdegeri;
            besin(degisecekbesinno,:)=yenibesin;
            denemesayisi(degisecekbesinno)=0;
            if eniyicozumdegeri>yenicozumdegeri
                
                eniyicozumdegeri=yenicozumdegeri;
                
                eniyicozum=yenibesin;
            end
            
        else
            
            denemesayisi(degisecekbesinno)=denemesayisi(degisecekbesinno)+1;
            
        end
        
    end
    
    % ÝÞÇÝ ari safhasi bitti 
    % gozcu ari safhasi baslar
    
    sabit=1;    
    for i=1:besinsayisi        
        minicinuygunluk(i)=sabit/cozumdegeri(i);        
    end    
    cozumdegerleritoplami=0;
    for i=1:besinsayisi        
        cozumdegerleritoplami=cozumdegerleritoplami+minicinuygunluk(i);        
    end    
    for i=1:besinsayisi        
        uygunluk(i)=minicinuygunluk(i)/cozumdegerleritoplami;        
    end    
    for i=1:gozcuarisayisi        
        degisecekbesinno=besinsec(uygunluk);
        r=rand(1);        
        indisl=randi([1 sehirsayisi]);
        indis2=randi([1 sehirsayisi]);
        while indisl==indis2            
            indis2=randi([1 sehirsayisi]);            
        end        
        if r<1/3            
            yenibesin=yerdegistir(besin(degisecekbesinno,:),indisl,indis2);
        elseif r<2/3            
            yenibesin=diziyiterscevir(besin(degisecekbesinno,:),indisl,indis2)            
        else            
            yenibesin=solakaydir(besin(degisecekbesinno,:),indisl,indis2);            
        end        
        yenicozumdegeri=amacfonksiyonu(yenibesin,ilmesafe,sehirsayisi);
        if yenicozumdegeri<cozumdegeri(degisecekbesinno)            
            cozumdegeri(degisecekbesinno)=yenicozumdegeri;
            besin(degisecekbesinno,:)=yenibesin; denemesayisi(degisecekbesinno)=0;
            if eniyicozumdegeri>yenicozumdegeri                
                eniyicozumdegeri=yenicozumdegeri;
                eniyicozum=yenibesin;
            end            
        else            
            denemesayisi(degisecekbesinno)=denemesayisi(degisecekbesinno)+1;            
        end        
    end
    
    % gozcu ari safhasi bitti
    % kaþif ari safhasi baslar
    for i=1:besinsayisi        
        if denemesayisi(i)>limit; 
            denemesayisi(i)=0;            
            [besin(i,:),cozumdegeri(i)]=YerelArama1(besin(i,:),cozumdegeri(i), ilmesafe,sehirsayisi)
            if eniyicozumdegeri>cozumdegeri(i)                
                eniyicozumdegeri=cozumdegeri(i); eniyicozum=besin(i,:);                
            end            
            [besin(i,:),cozumdegeri(i)]=YerelArama2(besin(i,:),cozumdegeri(i),ilmesafe,sehirsayisi)
            if eniyicozumdegeri>cozumdegeri(i)                
                eniyicozumdegeri=cozumdegeri(i); eniyicozum=besin(i,:);                
            end            
        end
    end
    
    % kaþif ari safhasi bitti
    fprintf('iterasyon %d EniyiCozum: %d \n', iterasyon, eniyicozumdegeri);
    fprintf('En iyi Çözüm yolu: ');
    fprintf('%d ',eniyicozum);
end