#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my ($read1,$read2,$sample);
my ($tophatmapped,$tophatunmapped);
my $tophatout=0;

sub usage{
	die(
		"
	Usage: tophatrun.pl -read1 sample1.read1.fq.gz,sample2.read1.fq.gz -read2 sample1.read2.fq.gz,sample2.read2.fq.gz -sample sample1,sample2
	Command: -read1 read1 file path (Must)
		 -read2 read2 file path (Must)
		 -sample tophat output folder (Must)
		 \n"
	 )
 }


GetOptions(
	'read1=s'=>\$read1,
	'read2=s'=>\$read2,
	'sample=s'=>\$sample,
);

&usage unless(defined($read1) && defined($sample));

($tophatmapped,$tophatunmapped)=alignment($read1,$read2,$sample);

while(1){
	if($tophatout){
		print "Featurecount\n";
		system("featureCounts -a /kydata/yangwentao/Human_genome/GCF_000001405.39_GRCh38.p13_genomic.gtf  -t 'gene' -F 'GTF' -T 20 -s 0  -B  -C -o allsample_geneid.featureCount @$tophatmapped");
		last;
	}else{
		sleep(100);
		print "wating for tophat output\n";
		$tophatout=checkfile(@$tophatunmapped);
		next;
	}
}


sub checkfile{
	my (@filelist)=@_;
	my $tag=0;
	foreach(@filelist){
	        if(-e $_){
			$tag=1;
			next;
		}else{
			$tag=0;
			last;
		}
	}
	return $tag;
}

sub alignment{
	my ($r1,$r2,$sample)=@_;
	my $i;
	my @mapped;
	my @unmapped;
	my (@read1,@read2,@sample);
	@read1=split(/,/,$r1);
	@read2=split(/,/,$r2);
	@sample=split(/,/,$sample);
	if($#read1==$#sample){
		for($i=0;$i<=$#read1;$i++){
			system("nohup tophat2 -p 4 -o $sample[$i]_tophatout /kydata/yangwentao/Human_genome/human_genome $read1[$i] $read2[$i] 2>err.log&\n");
			push @mapped,"./$sample[$i]_tophatout/accepted_hits.bam";
			push @unmapped,"./$sample[$i]_tophatout/unaccepted_hits.bam";

		}
	}
	return (\@mapped,\@unmapped);
}
