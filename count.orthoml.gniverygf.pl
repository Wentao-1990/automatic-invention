#!/usr/bin/perl -w
use strict;
if(@ARGV<1){
        die "Usage $0 Dirname mcloutput\n";
        }
my @spe;
my (%hs_count,%hs_gf);
my ($i,$j,$gf);
my @ar;
opendir DIR, $ARGV[0];
my @dir=readdir DIR;
foreach (@dir){
        if($_=~/fasta/){
                $_=~s/\.fasta//;
                push @spe,$_;
                }
        }
open FL,$ARGV[1];
while(<FL>){
        chomp;
        $j++;
        $gf="GeneFamily$j";
        foreach my $spe(@spe){
                $hs_count{$spe}=0;
                }
        @ar=split(/\s+/,$_);
        for($i=1;$i<=$#ar;$i++){
                $ar[$i]=~s/\|.*//;
                $hs_count{$ar[$i]}++;
                }
        foreach my $spe(@spe){
                if($hs_count{$spe}){
                        $hs_gf{$gf}.="$hs_count{$spe}\t";
                        }else{
                        $hs_gf{$gf}.="0\t";
                        }
                }
        
        }
print "GeneFamily\t".join("\t",@spe)."\n";
foreach(keys %hs_gf){
        if($hs_gf{$_}){
                $hs_gf{$_}=~s/\t$//;
                print "$_:\t$hs_gf{$_}\n";
                }
        }       
