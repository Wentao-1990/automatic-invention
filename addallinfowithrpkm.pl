#!/usr/bin/perl -w
use strict;
my (%hs_fpkm,%hs_ann);
my (@ele,@ar,@arr);
my (%hs_gene,%hs_con);
my $con_id;
my @id;
my $count=0;
open RPKM,$ARGV[0];
while(<RPKM>){
	chomp;
	$_=~s/\t$//;
	$count++;
	if($count==1){
		push @id,$_;
		next;
	}
	@arr=split(/\t/,$_);
	$hs_fpkm{$arr[0]}=$_;
	$hs_gene{"$arr[1]\t$arr[2]\t$arr[3]"}=$arr[0];
}

$count=0;
open ANN,$ARGV[1];
while(<ANN>){
	chomp;
	$count++;
	if($count==1){
		push @id,$_;
		next;
	}
	@ar=split(/\t/,$_);
	if($ar[0]=~/gene/){
		$hs_ann{"$ar[6]\t$ar[7]\t$ar[8]"}="$_";
		}
	}

foreach(keys %hs_ann){
	if($hs_gene{$_}){
		$con_id="$hs_gene{$_}";
		$hs_con{$con_id}="$hs_fpkm{$con_id}\t$hs_ann{$_}";
	}
}

print "GeneID\t".join("\t",@id)."\n";
foreach(keys %hs_con){
	if($hs_con{$_}){
		print "$_\t$hs_con{$_}\n";
		}
	}




	#sub hashele{
	#my ($file)=@_;
	#my @ar;
	#my %hs_ele;
	#open FL,$file;
	#while(<FL>){
	#		chomp;
	#		@ar=split(/\t/,$_);
	#		$hs_ele{$ar[0]}=$_;
	#}
	#return %hs_ele;
	#}
