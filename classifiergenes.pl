#!/usr/bin/perl -w
use strict;
if($#ARGV <6){
	die "Usage: perl $0 rpkmwithannotaion match(1)|mismatch(0) FeatureType Sample1_column Sample2_column Description_column \
	FeatureType_column\n";
}

my %hs_pro;
my $count;

%hs_pro =filterlow(classifer($ARGV[0],$ARGV[1],$ARGV[2],$ARGV[3],$ARGV[4],$ARGV[5],$ARGV[6]));

$count=counthash(%hs_pro);

print "#1.2\n";
print "$count\t6\n";
print "NAME\tDescription\tControl1\tControl2\tControl3\tTreatment1\tTreatment2\tTreatment3\n";
printhash(%hs_pro);

sub classifer{
	my ($file,$tag,$class,$colum1,$colum2,$feature,$type)=@_;
	#print "$match";
	my @ar;
	my %hs_class;
	my ($sample1,$sample2);
	my ($start_1,$end_1)=split(/:/,$colum1);
	my ($start_2,$end_2)=split(/:/,$colum2);
	open FL,$file;
	while(<FL>){
		chomp;
		$sample1='';
		$sample2='';
		if($_!~/^Gene/){
			@ar=split(/\t/,$_);

			$sample1 = join("\t",@ar[$start_1..$end_1]);
			$sample2 = join("\t",@ar[$start_2..$end_2]);
			if($tag){
				if($ar[$type]=~ /$class/){
					if($ar[$feature]){
						$hs_class{$ar[1]}="$ar[1]\t$ar[$feature]\t$sample1\t$sample2\n";
					}else{
						$hs_class{$ar[1]}="$ar[1]\tNA\t$sample1\t$sample2\n";
					}
				}
			
			}else{
				if($ar[$type] !~ /$class/){
					if($ar[$feature]){
						$hs_class{$ar[1]}="$ar[1]\t$ar[$feature]\t$sample1\t$sample2\n";
					}else{
						$hs_class{$ar[1]}="$ar[1]\tNA\t$sample1\t$sample2\n";
					}
				}
			}

		}
	}
	return %hs_class;
}


sub filterlow{
	my (%hs_rpkm)=@_;
	my %hs_filter;
	my ($gene1,$gene2);
	my @ar;
	my ($i,$j);
	for(keys %hs_rpkm){
		#print "$hs_rpkm{$_}";
		$gene1=0;
		$gene2=0;
		@ar=split(/\t/,$hs_rpkm{$_});
		for($i=2;$i<=4;$i++){
			if($ar[$i]==0){
				$gene1++;
			}
			}
		for($j=5;$j<=7;$j++){
			if($ar[$j]==0){
				$gene2++;
			}
		}
		#print "$gene1\t$gene2\n";
	if($gene1<=1 or $gene2<=1){
			$hs_filter{$ar[0]}=$hs_rpkm{$_};
		}
	}
	return %hs_filter;
}


sub counthash{
	my (%hs_keys)=@_;
	my $count=keys %hs_keys;
	return $count;
}

sub printhash{
	my (%hs_keys)=@_;
	foreach(keys %hs_keys){
		if($hs_keys{$_}){
			print "$hs_keys{$_}";
		}
	}
}
