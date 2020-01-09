#!/usr/bin/perl -w
use strict;
if(@ARGV<2){
        die "Usage $0 Dirname groupout gfnumber\n";
        }
my @spe;
my (%hs_count,%hs_gf,%hs_gn);
my ($i,$j,$gf,$output);
my (@ar,@ele,@gf_key);
opendir DIR, $ARGV[0];
my @dir=readdir DIR;
foreach (@dir){
        if($_=~/fasta/){
                $_=~s/\.fasta//;
                mkdir "$_"."_Genefamily";
                }
        }
open GP,$ARGV[1];
while(<GP>){
        chomp;
        @ar=split(/\s+/,$_);
        for($i=1;$i<=$#ar;$i++){
                my $tmp=$ar[$i];
                $tmp=~s/\|.*//;
                $hs_gf{"$ar[0]\t$tmp"}.="$ar[$i]\n";
                }
        }
open GN,$ARGV[2];
while(<GN>){
        chomp;
        @ele=split(/\t/,$_);
        $hs_count{$ele[0]}=0;
        $hs_gn{$ele[0]}=$_;
        for($j=1;$j<=$#ele;$j++){
                if($ele[$j]=~/\d/ and $ele[$j]!=0){
                        $hs_count{$ele[0]}+=1;
                        }
                }
        }
foreach(keys %hs_gf){
        chomp;
        @gf_key=split(/\t/,$_);
        if($hs_count{$gf_key[0]}){
                $output="$gf_key[1]"."_Genefamily/"."$gf_key[1]"."_"."$hs_count{$gf_key[0]}"."\.txt";
                open O,">>$output";
                print O "$hs_gf{$_}";
                }
        }
foreach (keys %hs_gn){
        if($hs_count{$_}){
                open F,">>all.$hs_count{$_}.txt";
                print F "$hs_gn{$_}\n";
                }
        }
