function SegmentoAudio=findSegment(express)
if express(1)==0
    IndiceAdquirido=find(express);                    
else
    IndiceAdquirido=express;
end

SegmentoAudio = [];
k = 1;
SegmentoAudio(k).begin = IndiceAdquirido(1);           
for i=1:length(IndiceAdquirido)-1,
	if IndiceAdquirido(i+1)-IndiceAdquirido(i)>1,         
		SegmentoAudio(k).end = IndiceAdquirido(i);      
		SegmentoAudio(k+1).begin = IndiceAdquirido(i+1);
		k = k+1;
	end
end
SegmentoAudio(k).end = IndiceAdquirido(end);            

for i=1 :k
    SegmentoAudio(i).duration=SegmentoAudio(i).end-SegmentoAudio(i).begin+1;
end