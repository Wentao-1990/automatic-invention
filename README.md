# Some scripts for the downstream analyses of OrthoMCL:
  1. 	classifier.orthmlcgf.pl
  2.  count.orthoml.gniverygf.pl
  
####get all 1:1 single copy gene families###
less all.16.txt|perl -ne 'chomp;@ar=split(/\t/,$_);$total=0;for($i=1;$i<=$#ar;$i++){$total+=$ar[$i]};if($total==16){print "$_\n"}' >phylogysinglecopy.gn.txt
awk -F ' '  'NR==FNR{a[$1]=$_;next}NR>FNR{if($1 in a){print a[$1]} else {print $0 "\t" "None"}}'  phylogene.addcor.txt phylogysinglecopy.gn.txt >phylogysinglecopy.id.txt

###model selectiion####
nohup java -jar /media/data5/yangwentao/software/prottest-3.4.2/prottest-3.4.2.jar -i phylogysinglecopy.nex  -threads 10  -S 2 -all-distributions -F -AIC -BIC -tc 0.5 > protest.output 2>err.log&
