#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use File::Basename;

my ($read1,$read2,$sample,$rawdata);
my ($gtf, $genome);
my ($trimread1,$trimread2,$trimlog);
my ($tophatmapped,$tophatunmapped);
my $tophatout=0;
my $cleardata1=0;
my $cleardata2=0;
my (@read1,@read2);
sub usage{
	die(
		"
	Usage: rnaseq_processing.pl -read1 sample1.read1.fq.gz,sample2.read1.fq.gz -read2 sample1.read2.fq.gz,sample2.read2.fq.gz -sample sample1,sample2 -genome indexed genome with bowtie2-build -gtf gtf annotation file -rawdata 1 (raw data)/0 (clear data, default)
	Command: -read1 read1 file path (Must)
		 -read2 read2 file path (Must)
		 -sample tophat output folder (Must)
		 -rawdata raw data(1)/ clean data(0)
		 -gtf gtf file (Must)
		 -genome indexed genome (Must)
		 \n"
	 )
 }


GetOptions(
	'read1=s'=>\$read1,
	'read2=s'=>\$read2,
	'sample=s'=>\$sample,
	'rawdata=i'=>\$rawdata,
	'gtf=s'=>\$gtf,
	'genome=s'=>\$genome
);

&usage unless(defined($read1) && defined($sample) && defined($rawdata) && defined($gtf) && defined($genome));

if($rawdata){
	print "####start trim raw data####\n";
	($trimread1,$trimread2,$trimlog)=trimrawread($read1,$read2,$sample);
	while(1){
		if($cleardata1 && $cleardata2){
			print "####start tophat alignment###\n";
			sleep(3000);
			($tophatmapped,$tophatunmapped)=alignment($trimread1,$trimread2,$sample);
			last;
		}else{
			$cleardata1=checkfile(@$trimread1);
			$cleardata2=checkfile(@$trimread2);
			next;
		}
	}
}else{
	@read1=split(/,/,$read1);
	@read2=split(/,/,$read2);
	($tophatmapped,$tophatunmapped)=alignment(\@read1,\@read2,$sample);
}



print "####start featureCount####\n";

while(1){
	if($tophatout){
		print "Featurecount\n";
		system("featureCounts -a $gtf  -t 'gene' -F 'GTF' -T 20 -s 0  -B  -C -o allsample_geneid.featureCount @$tophatmapped");
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

sub trimrawread{
	my ($r1,$r2,$sample)=@_;
	my ($trim_r1,$trim_r2,$trim_log);
	my $i;
	my @trimread1;
	my @trimread2;
	my @trimlog;
	my (@read1,@read2,@sample);
	my ($r1_name,$r2_name);
	@read1=split(/,/,$r1);
	@read2=split(/,/,$r2);
	@sample=split(/,/,$sample);
	if($#read1==$#sample){
		for($i=0;$i<=$#read1;$i++){
			$r1_name=basename($read1[$i],'.fq.gz').'_val_1.fq.gz';
			$r2_name=basename($read2[$i],'.fq.gz').'_val_2.fq.gz';
			$trim_log=basename($read2[$i]).'_trimming_report.txt';
			system "nohup trim_galore -q 20 --phred33 --stringency 3 --length 20 -e 0.1 -o  $sample[$i]_trimout -paired $read1[$i] $read2[$i] 2>err.log&\n";
			push @trimread1,"./$sample[$i]_trimout/$r1_name";
			push @trimread2,"./$sample[$i]_trimout/$r2_name";
			push @trimlog,"./$sample[$i]_trimout/$trim_log";

		}
	}
	return (\@trimread1,\@trimread2,\@trimlog);
}

sub alignment{
	my ($r1,$r2,$sample)=@_;
	my $i;
	my @mapped;
	my @unmapped;
	my @sample;
	@sample=split(/,/,$sample);
	if($#$r1 == $#$r2){
		for($i=0;$i<=$#$r1;$i++){
			system "nohup tophat2 -p 4 -o $sample[$i]_tophatout $genome $$r1[$i] $$r2[$i] 2>err.log&\n";
			push @mapped,"./$sample[$i]_tophatout/accepted_hits.bam";
			push @unmapped,"./$sample[$i]_tophatout/unmapped.bam";
		}
	}
	return (\@mapped,\@unmapped);
}
