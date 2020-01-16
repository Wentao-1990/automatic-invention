#!/usr/bin/perl -w
use strict;
my (%hs_module,%hs_knum,%hs_minf);
my ($tag,$tmp);
my (%hs_g2k,%hs_k2m);

#####main progrom#######

open FL,$ARGV[0];
while(<FL>){
        chomp;
        if($_=~/(M\d+)/ or $_=~/\s+(\d+)/){
                $tag=$1;
                $_=~s/^\s+//;
                $hs_minf{$tag}=$_;
                }elsif($_=~/(K\d+)/){
                $tmp=$1;
                $hs_module{$tag}.="$1,";
                }elsif($_=~/(k\d+.*)/){
                $hs_knum{$tmp}=$1;
                }
        } 

%hs_g2k = hashrevtran(%hs_knum);
%hs_k2m = hashrevtran(%hs_module);

foreach(keys %hs_g2k){
        if($hs_g2k{$_} and $hs_k2m{$hs_g2k{$_}} and $hs_minf{$hs_k2m{$hs_g2k{$_}}}){
                print "$_\t$hs_g2k{$_}\t$hs_minf{$hs_k2m{$hs_g2k{$_}}}\n";
                }
        }

######subroutine for transform hash values and keys#####

sub hashrevtran{
        my (%hs_kraw)=@_;
        my @allgene;
        my %hs_trans;
        my $i;
        foreach (keys %hs_kraw){
                if($hs_kraw{$_}){
                        @allgene=split(/,/,$hs_kraw{$_});
                        for($i=0;$i<=$#allgene;$i++){
                                $allgene[$i]=~s/\s+//g;
                                $hs_trans{$allgene[$i]}=$_;
                                }
                        }
                }
        return %hs_trans;
        }
