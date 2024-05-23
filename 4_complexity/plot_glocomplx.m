function plot_glocomplx(ver)
% ver: norm / nonnorm

% load files
cd(['E:\#ECoGconsciousness\Connect\all\complexity'])
load global_complexity.mat

if string(ver)=="norm"
    awdata=nawgclx; locdata=nlocgclx;
else string(ver)=="nonnorm"
    awdata=awgclx; locdata=locgclx;
end

ctotal=[]; group=[];
ctotal=[awdata; locdata];
gaw=repmat(1,size(awdata,1),1); gloc=repmat(2,size(locdata,1),1); group=[gaw; gloc];

% boxplot
position = [1:3]; position([3:3:3])=[];
boxplot(ctotal,group,'positions',position,'symbol','');
    
color = repmat([0.8500 0.3250 0.0980; 0 0.4470 0.7410],1,1);
h = findobj(gca,'Tag','Box');
for j=1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),color(j,:),'FaceAlpha',.5);
end  
set(gca,'XTickLabel',{'Conscious','Unconscious'});       
bx = findobj('Tag','boxplot');
bxtmp=bx.Children; set(bxtmp,'LineWidth',1);
set(gca,'linewidth',1,'FontName','Arial');
ylim([-0.1 0.8]);
set(gcf,'units','normalized','outerposition',[0 0 0.4 0.6]);
% save boxplot
cd(['E:\#ECoGconsciousness\Connect\all\complexity'])
fname=['boxplot_glocomplex_' ver]; saveas(gcf,fname, 'meta'); saveas(gcf,fname, 'png'); close(gcf);

% lineplot
% figure()
% for ss=1:size(awdata,1)
% plot([awdata(ss,1) locdata(ss,1)])
% hold on
% end

end