%% 1. Increased
% settings
%connect='aec';
%connect='coh';
%connect='wpli';

nth=311; % number of H0

load (['D:\#ECoGconsciousness\ECoG electrode\BAloc4connect.mat'])
balabel_loc(find(balabel_loc(:,2)=="V3-5"),2)="V3_5";
atlas_loc=double(balabel_loc(:,[7:9]));
fbtxt={'Delta','Theta','Alpha','Beta','LG','HG'};
input_surface={'surf_reg_model_left.obj'};
atlas_filename={'aal_atlas_left_surf.txt' 'aal_atlas_right_surf.txt' 'aal_label.txt'};

obj=struct('points',[],'normals',[],'tri',[]);
npoints=0;
for nsurf=1:length(input_surface)
    tmp=loadmniobj(input_surface{nsurf});
    obj.points=cat(2,obj.points,tmp.points);
    obj.normals=cat(2,obj.normals,tmp.normals);
    obj.tri=cat(2,obj.tri,tmp.tri+npoints);
    npoints=npoints+size(tmp.points,2);
end

for ff=1:6
    %threp=0.05/nth; 
    threp=0.01/nth; 
    cd(['E:\#ECoGconsciousness\Connect\all\' connect '\statspss\lnresults'])
    load(['lnGEEresults_' connect '_' num2str(ff) fbtxt{ff} '.mat'])
    cresult=lncresult;

    [ctmp,~]=find(double(cresult(:,10))<=threp & double(cresult(:,9))>0);

    npair=[];

    % sort rois
    for cc=1:size(ctmp,1)
        rroi1=cresult(ctmp(cc),2); rroi2=cresult(ctmp(cc),3);
        npair(cc,1)=find(rroi1==balabel_loc(:,2)); npair(cc,2)=find(rroi2==balabel_loc(:,2));
        npair(cc,3)=double(cresult(ctmp(cc),9)); % connectivity mean diff
    end

    if isempty(npair)
    else
    H1=figure(1);
    set(gcf,'Color','white')
    map=[0:255;0:255;0:255]'/255;
    colormap(map);
    Hs=trisurf(obj.tri', obj.points(1,:), obj.points(2,:), obj.points(3,:),...
       ones(1,size(obj.points,2))*100);
    fig1=get(H1);
    daspect([1 1 1]);
    lighting gouraud
    alpha(0.4)
    set(Hs, 'EdgeAlpha', 0);
    set(Hs, 'AmbientStrength', 0.4, 'DiffuseStrength', 0.7);
    axis off
    set(fig1.Children(length(fig1.Children)), 'CameraPosition', [-1000 0 0],...
       'CameraUpVector', [0 0 1]); % L hemi, lateral
    camlight left
    camlight right

    % edge
    for i=1:size(npair,1)
        lx=[atlas_loc(npair(i,1),1) atlas_loc(npair(i,2),1)];
        ly=[atlas_loc(npair(i,1),2) atlas_loc(npair(i,2),2)];
        lz=[atlas_loc(npair(i,1),3) atlas_loc(npair(i,2),3)];  
        if npair(i,3)>0; Hl=line(lx', ly', lz', 'LineWidth', 3, 'Color', [1 0 0]); % increased, red
        else Hl=line(lx', ly', lz', 'LineWidth', 3, 'Color', [0 0 1]); % decreased, blue
        end
        hold on
    end

    % Node
    nds=[npair(:,1); npair(:,2)]; nds=unique(nds);

    for nn=1:length(nds)
        nnode=nds(nn);
        c1=find(npair(:,1)==nnode); c2=find(npair(:,2)==nnode);
        numc=length(c1)+length(c2);
        nds(nn,2)=numc;
    end

    [x,y,z]=sphere(50);
    hold on
    for i = 1:length(nds)
        nd = nds(i,1);
        %S=3; % node size    
        S=nds(i,2)/2.5; % node size    
        Hn=surf(x*S+atlas_loc(nd,1), y*S+atlas_loc(nd,2), z*S+atlas_loc(nd,3),'EdgeAlpha',0,'FaceColor',[.5 .5 .5]);
        % if sg==1; Hn=surf(x*S+atlas_loc(nd,1), y*S+atlas_loc(nd,2), z*S+atlas_loc(nd,3),'EdgeAlpha',0,'FaceColor',[1 0 0]); % red
        % else Hn=surf(x*S+atlas_loc(nd,1), y*S+atlas_loc(nd,2), z*S+atlas_loc(nd,3),'EdgeAlpha',0,'FaceColor',[0 0 1]); % blue
        % end
        txt = balabel_loc(nd,2); text(atlas_loc(nd,1)-70,atlas_loc(nd,2)-1,atlas_loc(nd,3)+3,txt,'FontWeight','bold')
    end
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);

    % save fig
    cd(['E:\#ECoGconsciousness\Connect\all\' connect '\statspss\lnresults\brainplot'])
    %fname=['lnGEE_' connect '_' num2str(ff) fbtxt{ff} '_plus_dg']; saveas(gcf,fname, 'fig'); saveas(gcf,fname, 'png');    
    fname=['lnGEE001_' connect '_' num2str(ff) fbtxt{ff} '_plus_dg']; saveas(gcf,fname, 'fig'); saveas(gcf,fname, 'png');   
    close(gcf);
    end

    clear npair
end

%% 2. Decreased
% settings
%connect='aec';
%connect='coh';
connect='wpli';

nth=311; % number of H0

load (['D:\#ECoGconsciousness\ECoG electrode\BAloc4connect.mat'])
balabel_loc(find(balabel_loc(:,2)=="V3-5"),2)="V3_5";
atlas_loc=double(balabel_loc(:,[7:9]));
fbtxt={'Delta','Theta','Alpha','Beta','LG','HG'};
input_surface={'surf_reg_model_left.obj'};
atlas_filename={'aal_atlas_left_surf.txt' 'aal_atlas_right_surf.txt' 'aal_label.txt'};

obj=struct('points',[],'normals',[],'tri',[]);
npoints=0;
for nsurf=1:length(input_surface)
    tmp=loadmniobj(input_surface{nsurf});
    obj.points=cat(2,obj.points,tmp.points);
    obj.normals=cat(2,obj.normals,tmp.normals);
    obj.tri=cat(2,obj.tri,tmp.tri+npoints);
    npoints=npoints+size(tmp.points,2);
end

for ff=1:6
    %threp=0.05/nth; 
    threp=0.01/nth; 
    cd(['E:\#ECoGconsciousness\Connect\all\' connect '\statspss\lnresults'])
    load(['lnGEEresults_' connect '_' num2str(ff) fbtxt{ff} '.mat'])
    cresult=lncresult;

    [ctmp,~]=find(double(cresult(:,10))<=threp & double(cresult(:,9))<0);

    npair=[];

    % sort rois
    for cc=1:size(ctmp,1)
        rroi1=cresult(ctmp(cc),2); rroi2=cresult(ctmp(cc),3);
        npair(cc,1)=find(rroi1==balabel_loc(:,2)); npair(cc,2)=find(rroi2==balabel_loc(:,2));
        npair(cc,3)=double(cresult(ctmp(cc),9));
    end

    if isempty(npair)
    else
    H1=figure(1);
    set(gcf,'Color','white')
    map=[0:255;0:255;0:255]'/255;
    colormap(map);
    Hs=trisurf(obj.tri', obj.points(1,:), obj.points(2,:), obj.points(3,:),...
       ones(1,size(obj.points,2))*100);
    fig1=get(H1);
    daspect([1 1 1]);
    lighting gouraud
    alpha(0.4)
    set(Hs, 'EdgeAlpha', 0);
    set(Hs, 'AmbientStrength', 0.4, 'DiffuseStrength', 0.7);
    axis off
    set(fig1.Children(length(fig1.Children)), 'CameraPosition', [-1000 0 0],...
       'CameraUpVector', [0 0 1]); % L hemi, lateral
    camlight left
    camlight right

    % edge
    for i=1:size(npair,1)
        lx=[atlas_loc(npair(i,1),1) atlas_loc(npair(i,2),1)];
        ly=[atlas_loc(npair(i,1),2) atlas_loc(npair(i,2),2)];
        lz=[atlas_loc(npair(i,1),3) atlas_loc(npair(i,2),3)];  
        if npair(i,3)>0; Hl=line(lx', ly', lz', 'LineWidth', 3, 'Color', [1 0 0]); % increased, red
        else Hl=line(lx', ly', lz', 'LineWidth', 3, 'Color', [0 0 1]); % decreased, blue
        end
        hold on
    end

    % Node
    nds=[npair(:,1); npair(:,2)]; nds=unique(nds);

    for nn=1:length(nds)
        nnode=nds(nn);
        c1=find(npair(:,1)==nnode); c2=find(npair(:,2)==nnode);
        numc=length(c1)+length(c2);
        nds(nn,2)=numc;
    end

    [x,y,z]=sphere(50);
    hold on
    for i = 1:length(nds)
        nd = nds(i,1);
        %S=3; % node size    
        S=nds(i,2)/2.5; % node size     
        Hn=surf(x*S+atlas_loc(nd,1), y*S+atlas_loc(nd,2), z*S+atlas_loc(nd,3),'EdgeAlpha',0,'FaceColor',[.5 .5 .5]);
        % if sg==1; Hn=surf(x*S+atlas_loc(nd,1), y*S+atlas_loc(nd,2), z*S+atlas_loc(nd,3),'EdgeAlpha',0,'FaceColor',[1 0 0]); % red
        % else Hn=surf(x*S+atlas_loc(nd,1), y*S+atlas_loc(nd,2), z*S+atlas_loc(nd,3),'EdgeAlpha',0,'FaceColor',[0 0 1]); % blue
        % end
        txt = balabel_loc(nd,2); text(atlas_loc(nd,1)-70,atlas_loc(nd,2)-1,atlas_loc(nd,3)+3,txt,'FontWeight','bold')
    end
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);

    % save fig
    cd(['E:\#ECoGconsciousness\Connect\all\' connect '\statspss\lnresults\brainplot'])
    %fname=['lnGEE_' connect '_' num2str(ff) fbtxt{ff} '_minus_dg']; saveas(gcf,fname, 'fig'); saveas(gcf,fname, 'png');    
    fname=['lnGEE001_' connect '_' num2str(ff) fbtxt{ff} '_minus_dg']; saveas(gcf,fname, 'fig'); saveas(gcf,fname, 'png');   
    close(gcf);
    end

    clear npair
end

%% 3. Both
% settings
%connect='aec';
%connect='coh';
connect='wpli';

nth=311; % number of H0

load (['D:\#ECoGconsciousness\ECoG electrode\BAloc4connect.mat'])
balabel_loc(find(balabel_loc(:,2)=="V3-5"),2)="V3_5";
atlas_loc=double(balabel_loc(:,[7:9]));
fbtxt={'Delta','Theta','Alpha','Beta','LG','HG'};
input_surface={'surf_reg_model_left.obj'};
atlas_filename={'aal_atlas_left_surf.txt' 'aal_atlas_right_surf.txt' 'aal_label.txt'};

obj=struct('points',[],'normals',[],'tri',[]);
npoints=0;
for nsurf=1:length(input_surface)
    tmp=loadmniobj(input_surface{nsurf});
    obj.points=cat(2,obj.points,tmp.points);
    obj.normals=cat(2,obj.normals,tmp.normals);
    obj.tri=cat(2,obj.tri,tmp.tri+npoints);
    npoints=npoints+size(tmp.points,2);
end

for ff=1:6
    %threp=0.05/nth; 
    threp=0.01/nth; 
    cd(['E:\#ECoGconsciousness\Connect\all\' connect '\statspss\lnresults'])
    load(['lnGEEresults_' connect '_' num2str(ff) fbtxt{ff} '.mat'])
    cresult=lncresult;

    [ctmp,~]=find(double(cresult(:,10))<=threp);

    npair=[];

    % sort rois
    for cc=1:size(ctmp,1)
        rroi1=cresult(ctmp(cc),2); rroi2=cresult(ctmp(cc),3);
        npair(cc,1)=find(rroi1==balabel_loc(:,2)); npair(cc,2)=find(rroi2==balabel_loc(:,2));
        npair(cc,3)=double(cresult(ctmp(cc),9));
    end

    if isempty(npair)
    else
    H1=figure(1);
    set(gcf,'Color','white')
    map=[0:255;0:255;0:255]'/255;
    colormap(map);
    Hs=trisurf(obj.tri', obj.points(1,:), obj.points(2,:), obj.points(3,:),...
       ones(1,size(obj.points,2))*100);
    fig1=get(H1);
    daspect([1 1 1]);
    lighting gouraud
    alpha(0.4)
    set(Hs, 'EdgeAlpha', 0);
    set(Hs, 'AmbientStrength', 0.4, 'DiffuseStrength', 0.7);
    axis off
    set(fig1.Children(length(fig1.Children)), 'CameraPosition', [-1000 0 0],...
       'CameraUpVector', [0 0 1]); % L hemi, lateral
    camlight left
    camlight right

    % edge
    for i=1:size(npair,1)
        lx=[atlas_loc(npair(i,1),1) atlas_loc(npair(i,2),1)];
        ly=[atlas_loc(npair(i,1),2) atlas_loc(npair(i,2),2)];
        lz=[atlas_loc(npair(i,1),3) atlas_loc(npair(i,2),3)];  
        if npair(i,3)>0; Hl=line(lx', ly', lz', 'LineWidth', 3, 'Color', [1 0 0]); % increased, red
        else Hl=line(lx', ly', lz', 'LineWidth', 3, 'Color', [0 0 1]); % decreased, blue
        end
        hold on
    end

    % Node
    nds=[npair(:,1); npair(:,2)]; nds=unique(nds);
    for nn=1:length(nds)
        nnode=nds(nn);
        c1=find(npair(:,1)==nnode); c2=find(npair(:,2)==nnode);
        numc=length(c1)+length(c2);
        nds(nn,2)=numc;
    end
    [x,y,z]=sphere(50);
    hold on
    for i = 1:length(nds)
        nd = nds(i,1);
        %S=3; % node size    
        S=nds(i,2)/2.5; % node size    
        Hn=surf(x*S+atlas_loc(nd,1), y*S+atlas_loc(nd,2), z*S+atlas_loc(nd,3),'EdgeAlpha',0,'FaceColor',[.5 .5 .5]);
        % if sg==1; Hn=surf(x*S+atlas_loc(nd,1), y*S+atlas_loc(nd,2), z*S+atlas_loc(nd,3),'EdgeAlpha',0,'FaceColor',[1 0 0]); % red
        % else Hn=surf(x*S+atlas_loc(nd,1), y*S+atlas_loc(nd,2), z*S+atlas_loc(nd,3),'EdgeAlpha',0,'FaceColor',[0 0 1]); % blue
        % end
        txt = balabel_loc(nd,2); text(atlas_loc(nd,1)-70,atlas_loc(nd,2)-1,atlas_loc(nd,3)+3,txt,'FontWeight','bold')
    end
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);

    % save fig
    cd(['E:\#ECoGconsciousness\Connect\all\' connect '\statspss\lnresults\brainplot'])
    %fname=['lnGEE_' connect '_' num2str(ff) fbtxt{ff} '_dg']; saveas(gcf,fname, 'fig'); saveas(gcf,fname, 'png');    
    fname=['lnGEE001_' connect '_' num2str(ff) fbtxt{ff} '_dg']; saveas(gcf,fname, 'fig'); saveas(gcf,fname, 'png');   
    close(gcf);
    end

    clear npair
end