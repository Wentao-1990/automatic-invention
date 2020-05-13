#!/usr/bin/perl -w
#This script is used for the downstream analysis of MCScanx for the ka/ks calculations.
#################################################################
#########Prerequired tools ######################################
# muscle                                                        #
# RevTrans-1.4                                                  #
# Kaks_calculater                                               #               
#################################################################

use strict;
my %hs_pep;
my %hs_cds;
my $tag;
%hs_pep=hash_seq($ARGV[0]);
%hs_cds=hash_seq($ARGV[1]);
open FL,$ARGV[2];
while(<FL>){
        chomp;
        if($_=~/(\d+)-\s+(\d+):\s+(\S+)\s+(\S+)/){
                open P,">$1.$2.pep";
                if($hs_pep{$3} and $hs_pep{$4}){
                        print P ">$3\n$hs_pep{$3}\n>$4\n$hs_pep{$4}\n";
                        }
                open C,">$1.$2.cds";
                if($hs_cds{$3} and $hs_cds{$4}){
                        print C ">$3\n$hs_cds{$3}\n>$4\n$hs_cds{$4}\n";
                        }
                system "muscle -in $1.$2.pep -out $1.$2.muscle\n";
                system "python2 /media/data3/yangwentao/RevTrans-1.4/revtrans.py  $1.$2.cds $1.$2.muscle  -mtx 6  -match  trans >$1.$2.revtrans\n";
                revtran2axt("$1.$2.revtrans");
                system "KaKs_Calculator -i $1.$2.revtrans.axt  -o $1.$2.ynkaks -m YN -c 6\n";
                }
        }

#system "sh runrevtrans.sh";
#system "sh runcalkaks.sh";
system "mkdir $ARGV[2]_cds ; mv *.cds $ARGV[2]_cds";
system "mkdir $ARGV[2]_pep ; mv *.pep $ARGV[2]_pep";
system "mkdir $ARGV[2]_muscle ; mv *.muscle $ARGV[2]_muscle";
system "mkdir $ARGV[2]_revtrans ; mv *.revtrans $ARGV[2]_revtrans";
system "mkdir $ARGV[2]_axt ; mv *.axt $ARGV[2]_axt";
system "mkdir $ARGV[2]_ynkaks ; mv *.ynkaks $ARGV[2]_ynkaks";


sub hash_seq{
        my ($file)=@_;
        my $tag;
        my %hs_seq;
        open FL,$file;
        while(<FL>){
                chomp;
                if($_=~/^>(\S+)/){
                        $tag=$1;
                        }else{
                        $hs_seq{$tag}.=$_;
                        }
                }
        return %hs_seq;
        }
sub revtran2axt{
        my ($revfile)=@_;
        unless (open (MYFILE, $revfile)) {
                die ("Cannot open file\n");
                }
        my @array = <MYFILE>;
        chomp @array;

        my $count = 0;
        my @seq = ();
        my @name = ();
        my $tmp_seq = "";
        while ($count < @array) {
                if(index($array[$count], ">")==0) {
                        push(@name, substr($array[$count], 1, length($array[$count])-1));
                        if ($tmp_seq ne "") {
                                push(@seq, $tmp_seq);
                                $tmp_seq = "";
                                }       
                        }
                else {
                        $tmp_seq .= $array[$count];
                }
                $count++;

                if ($count==@array) {
                        push(@seq, $tmp_seq);
                        }

                }

        my $output  = join("-", @name)."\n";
        $output .= join("\n", @seq)."\n";
        $output .= "\n";
        my $outfile=${revfile}.".axt";
        open (OUTFILE, ">$outfile");
        print OUTFILE  "$output";
        }
