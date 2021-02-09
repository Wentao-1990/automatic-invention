#!/usr/bin/perl -w
use strict;
my (%gr1,%gr2,%gr3,%gr4,%gr5,%gr6,%gr7,%gr8,%gr9,%gr10,%gr11,%gr12,%gr13,%gr14,%gr15,%gr16,%gr17,%gr18,%gr19,%gr20,%gr21);
my ($fn1,$fn2);
%gr1= hashfpkm($ARGV[0]);
%gr2= hashfpkm($ARGV[1]);
%gr3= hashfpkm($ARGV[2]);
%gr4= hashfpkm($ARGV[3]);
%gr5= hashfpkm($ARGV[4]);
%gr6= hashfpkm($ARGV[5]);
%gr7= hashfpkm($ARGV[6]);
%gr8= hashfpkm($ARGV[7]);
%gr9= hashfpkm($ARGV[8]);
%gr10= hashfpkm($ARGV[9]);
%gr11= hashfpkm($ARGV[10]);
%gr12= hashfpkm($ARGV[11]);
%gr13= hashfpkm($ARGV[12]);
%gr14= hashfpkm($ARGV[13]);
%gr15= hashfpkm($ARGV[14]);
%gr16= hashfpkm($ARGV[15]);
%gr17= hashfpkm($ARGV[16]);
%gr18= hashfpkm($ARGV[17]);
%gr19= hashfpkm($ARGV[18]);
%gr20= hashfpkm($ARGV[19]);
%gr21= hashfpkm($ARGV[20]);
#$fn1=$ARGV[0];
#$fn2=$ARGV[1];
#$fn1=~s#/kydata/yangwentao/lcg_a549/##;
#$fn2=~s#/kydata/yangwentao/lcg_a549/##;
#$fn1=~s#.output/genes.fpkm_tracking##;
#$fn2=~s#.output/genes.fpkm_tracking##;
print "gene_id\tgene_short_name\t$ARGV[0]\t$ARGV[1]\t$ARGV[2]\t$ARGV[3]\t$ARGV[4]\t$ARGV[5]\t$ARGV[6]\t$ARGV[7]\t$ARGV[8]\t$ARGV[9]\t$ARGV[10]\t$ARGV[11]\t$ARGV[12]\t$ARGV[13]\t$ARGV[14]\t$ARGV[15]\t$ARGV[16]\t$ARGV[17]\t$ARGV[18]\t$ARGV[19]\t$ARGV[20]\n";
foreach(keys %gr1){
	if($gr2{$_} and $gr3{$_} and $gr4{$_} and $gr5{$_} and $gr6{$_} and $gr7{$_} and $gr8{$_} and $gr9{$_} and $gr10{$_} and $gr11{$_} and $gr12{$_} and $gr13{$_} and $gr14{$_} and $gr15{$_} and $gr16{$_} and $gr17{$_} and $gr18{$_} and $gr19{$_} and $gr20{$_} and $gr21{$_}){
		print "$_\t$gr1{$_}\t$gr2{$_}\t$gr3{$_}\t$gr4{$_}\t$gr5{$_}\t$gr6{$_}\t$gr7{$_}\t$gr8{$_}\t$gr9{$_}\t$gr10{$_}\t$gr11{$_}\t$gr12{$_}\t$gr13{$_}\t$gr14{$_}\t$gr15{$_}\t$gr16{$_}\t$gr17{$_}\t$gr18{$_}\t$gr19{$_}\t$gr20{$_}\t$gr21{$_}\n";
		}
	}


sub hashfpkm{
	my ($file)= @_;
	my %hs_fpkm;
	my @ar;
	open FL,$file;
	while(<FL>){
		chomp;
		@ar=split(/\t/,$_);
		$hs_fpkm{"$ar[3]\t$ar[4]"}="$ar[9],";
		}
	return %hs_fpkm;
}
