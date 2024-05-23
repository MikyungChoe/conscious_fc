%%
cd(['E:\#ECoGconsciousness\Connect\all\network\coh']); 
load result_net_limitch20_coh.mat

%% plot total
for i=1:6 %delta to HG
    % clustering coefficient
    subplot(2,6,i);
    x=[15:45];
    y1=mccfrest(:,i); 
    plot(x,y1,'-o','MarkerSize',3,'MarkerFaceColor','b','MarkerEdgeColor','b','linewidth',1.2)
    set(gca,'FontSize',10,'FontWeight','bold','linewidth',1.2,'FontName','Arial');
    hold on
    y2=mccfloc(:,i); 
    plot(x,y2,'-o','MarkerSize',3,'MarkerFaceColor','r','MarkerEdgeColor','r','linewidth',1.2)    
    test=abs(allwspccef); test(test>0.05)=NaN; test(test<0.05&test>0)=1*0.73;
    scatter(x,test(:,i), 10, "k", "*")    
    set(gca,'FontSize',10,'FontWeight','bold','linewidth',1.2,'FontName','Arial');
    xlim([12 47]); ylim([0.37 0.77])  
    
    % efficiency
    subplot(2,6,i+6);
    x=[15:45];
    y1=mgerest(:,i);
    plot(x,y1,'-o','MarkerSize',3,'MarkerFaceColor','b','MarkerEdgeColor','b','linewidth',1.2)
    set(gca,'FontSize',10,'FontWeight','bold','linewidth',1.2,'FontName','Arial');
    hold on
    y2=mgeloc(:,i); err2=sgeloc(:,i);
    plot(x,y2,'-o','MarkerSize',3,'MarkerFaceColor','r','MarkerEdgeColor','r','linewidth',1.2)
    test=abs(allwspge); test(test>0.05)=NaN; test(test<0.05&test>0)=1*0.75;
    scatter(x,test(:,i), 10, "k", "*")
    set(gca,'FontSize',10,'FontWeight','bold','linewidth',1.2,'FontName','Arial');
    xlim([12 47]); ylim([0.3 0.8])       
end
set(gcf,'units','normalized','outerposition',[0 0 1 0.5]);
cd(['E:\#ECoGconsciousness\Connect\all\network\coh\fig'])
fname=['lineplot_net_lmt20_chthr_total']; saveas(gcf,fname, 'meta');  
fname=['lineplot_net_lmt20_chthr_total']; saveas(gcf,fname, 'png'); close(gcf);   

%% plot 1
for i=1:3 %delta to alpha
    % clustering coefficient
    subplot(2,3,i);
    x=[15:45];
    y1=mccfrest(:,i); 
    plot(x,y1,'-o','MarkerSize',3,'MarkerFaceColor','b','MarkerEdgeColor','b','linewidth',1.2)
    set(gca,'FontSize',10,'FontWeight','bold','linewidth',1.2,'FontName','Arial');
    hold on
    y2=mccfloc(:,i); 
    plot(x,y2,'-o','MarkerSize',3,'MarkerFaceColor','r','MarkerEdgeColor','r','linewidth',1.2)    
    test=abs(allwspccef); test(test>0.05)=NaN; test(test<0.05&test>0)=1*0.73;
    scatter(x,test(:,i), 10, "k", "*")    
    set(gca,'FontSize',10,'FontWeight','bold','linewidth',1.2,'FontName','Arial');
    xlim([12 47]); ylim([0.37 0.77])  
    
    % efficiency
    subplot(2,3,i+3);
    x=[15:45];
    y1=mgerest(:,i);
    plot(x,y1,'-o','MarkerSize',3,'MarkerFaceColor','b','MarkerEdgeColor','b','linewidth',1.2)
    set(gca,'FontSize',10,'FontWeight','bold','linewidth',1.2,'FontName','Arial');
    hold on
    y2=mgeloc(:,i); err2=sgeloc(:,i);
    plot(x,y2,'-o','MarkerSize',3,'MarkerFaceColor','r','MarkerEdgeColor','r','linewidth',1.2)
    test=abs(allwspge); test(test>0.05)=NaN; test(test<0.05&test>0)=1*0.75;
    scatter(x,test(:,i), 10, "k", "*")
    set(gca,'FontSize',10,'FontWeight','bold','linewidth',1.2,'FontName','Arial');
    xlim([12 47]); ylim([0.3 0.8])       
end
set(gcf,'units','normalized','outerposition',[0 0 0.7 1]);
cd(['E:\#ECoGconsciousness\Connect\all\network\coh\fig'])
fname=['lineplot_net_lmt20_chthr1']; saveas(gcf,fname, 'meta');  
fname=['lineplot_net_lmt20_chthr1']; saveas(gcf,fname, 'png'); close(gcf);   

% plot 2
for i=4:6 %delta to alpha
    % clustering coefficient
    subplot(2,3,i-3);
    x=[15:45];
    y1=mccfrest(:,i); 
    plot(x,y1,'-o','MarkerSize',3,'MarkerFaceColor','b','MarkerEdgeColor','b','linewidth',1.2)
    set(gca,'FontSize',10,'FontWeight','bold','linewidth',1.2,'FontName','Arial');
    hold on
    y2=mccfloc(:,i); 
    plot(x,y2,'-o','MarkerSize',3,'MarkerFaceColor','r','MarkerEdgeColor','r','linewidth',1.2)
    test=abs(allwspccef); test(test>0.05)=NaN; test(test<0.05&test>0)=1*0.73;
    scatter(x,test(:,i), 10, "k", "*")    
    set(gca,'FontSize',10,'FontWeight','bold','linewidth',1.2,'FontName','Arial');
    xlim([12 47]); ylim([0.37 0.77])    
    
    % efficiency
    subplot(2,3,i);
    x=[15:45];
    y1=mgerest(:,i);
    plot(x,y1,'-o','MarkerSize',3,'MarkerFaceColor','b','MarkerEdgeColor','b','linewidth',1.2)
    set(gca,'FontSize',10,'FontWeight','bold','linewidth',1.2,'FontName','Arial');
    hold on
    y2=mgeloc(:,i); err2=sgeloc(:,i);
    plot(x,y2,'-o','MarkerSize',3,'MarkerFaceColor','r','MarkerEdgeColor','r','linewidth',1.2)
    test=abs(allwspge); test(test>0.05)=NaN; test(test<0.05&test>0)=1*0.75;
    scatter(x,test(:,i), 10, "k", "*")
    set(gca,'FontSize',10,'FontWeight','bold','linewidth',1.2,'FontName','Arial');
    xlim([12 47]); ylim([0.3 0.8])      
end
set(gcf,'units','normalized','outerposition',[0 0 0.7 1]);
cd(['E:\#ECoGconsciousness\Connect\all\network\coh\fig'])
fname=['lineplot_net_lmt20_chthr2']; saveas(gcf,fname, 'meta'); 
fname=['lineplot_net_lmt20_chthr2']; saveas(gcf,fname, 'png'); close(gcf); 