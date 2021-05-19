#!/usr/bin/perl -w
use strict;
#open FIVE,">fivr0verlap.gtf";
#open NO,">no.gtf";
#open THREE,">threeoverlap.gtf";
#open THESAME,">thesame.gtf";
#open CONTAINED,">contained.gtf";
#open CONTAIN,">contain.gtf";
#print STDERR "reading first gtf file\n";
open GTF1,$ARGV[0];
my %hsgtf1;
my %region1;

while (<GTF1>){
if ($_!~/^[\r\n]+$/){
        my @ar=split(/\t/,$_);
        (my $trans)=($ar[8]=~/transcript_id \"(.*?)\";.*/);
        $hsgtf1{$trans}.="$_";
        if ($ar[2] eq "transcript"){
                $region1{$trans}="$ar[3]\t$ar[4]\t$ar[0]";
        }
}
}


#print STDERR "reading second gtf file\n";
open GTF2,$ARGV[1];
my %hsgtf2;
my %region2;

while (<GTF2>){
if ($_!~/^[\r\n]+$/){
        my @ar=split(/\t/,$_);
        (my $trans)=($ar[8]=~/transcript_id \"(.*?)\"/);
        $hsgtf2{$trans}.="$_";
        if ($ar[2] eq "transcript"){
                $region2{$trans}="$ar[3]\t$ar[4]\t$ar[0]";
        }
}
}


my $c;
my %mark;
foreach my $key1 (keys %hsgtf1){
        $c++;
#       print STDERR "reading $c record\n";
        $mark{$key1}="no";
        my @tmp1=split(/\t/,$region1{$key1});

        foreach my $key2 (keys %hsgtf2){
                my @tmp2=split(/\t/,$region2{$key2});
        if ($tmp1[2] eq $tmp2[2]){
                if ($tmp1[0]<$tmp2[0] and $tmp1[1]>$tmp2[0] and $tmp1[1]<$tmp2[1]){
                        $mark{$key1}="five_overlap";
                }elsif (($tmp1[0]<$tmp2[0] and $tmp1[1]>=$tmp2[1]) or ($tmp1[0]==$tmp2[0] and $tmp1[1]>$tmp2[1])){
                        $mark{$key1}="contained";  
                }elsif ($tmp1[0]==$tmp2[0] and $tmp1[1]==$tmp2[1]){
                        $mark{$key1}="the_same";
                }elsif (($tmp1[0]>$tmp2[0] and $tmp1[1]<=$tmp2[1]) or($tmp1[0]==$tmp2[0] and $tmp1[1]<$tmp2[1])){
                        $mark{$key1}="contain";
                }elsif ($tmp1[0]>$tmp2[0] and $tmp1[0]<$tmp2[1] and $tmp1[1] >$tmp2[1]){
                        $mark{$key1}="three_overlap";
                        }
        }
        }
}

#print STDERR "writing results\n";
foreach my $key1 (keys %hsgtf1){
        if ($mark{$key1} eq "no"){
        #       my @ar=split(/\|\|/,$hsgtf1{$key1});
        #       foreach my $tag (@ar){
                        print  "$hsgtf1{$key1}";
        #       }elsif($mark{$key1} eq "five_overlap"){
        #               print FIVE "$hsgtf1{$key1}";
        #       }elsif($mark{$key1} eq "contained"){
        #               print CONTAINED "$hsgtf1{$key1}";
        #       }elsif($mark{$key1} eq "the_same"){
        #               print THESAME "$hsgtf1{$key1}";
        #       }elsif($mark{$key1} eq "contain"){
        #               print CONTAIN "$hsgtf1{$key1}";
        #       }elsif($mark{$key1} eq "three_overlap"){
        #               print THREE "$hsgtf1{$key1}";
                }
        }
