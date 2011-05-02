#!/usr/bin/perl

#use strict;
#use warnings;
use File::Basename;
use File::Copy;

open $CONFIG_file, "~/.rt-sort.cfg" or die "Unable to open config: $!\n";
my $config = join "", <$CONFIG_file>;
close $CONFIG_file;

eval $config;

my $runtime = `date +"%D %T:"`;
chomp($runtime);

#print $runtime."\n";

my $file = "@ARGV";

my $folder = "";

#print $file."\n";

my @hd_tags = ("720p", "1080p", "1080i");

if ($ARGV[$#ARGV] eq "SERIE") {
	$file =~ s/ SERIE$//;
	#print $file."\n";

	my $is_hd = 0;

	if ((-d $file) || (-e $file)) {
		#print "IS FILE OR FOLDER\n";
		my $bname = basename($file);
		#print $bname."WAT\n";
		foreach (@hd_tags) {
			if ($bname =~ m/$_/i) {
				$is_hd = 1;
			}
		}

		if ($is_hd) {
			$folder = $hdfolder;
		} else {
			$folder = $sdfolder;
		}

		$bname =~ m/(.*)(\.|\s)S([0-9]{1,2})E?[0-9]{0,2}|EP?[0-9]{1,2}(\.|\s)(720p|1080p|1080i)?\.?(.*)\.(x264|xvid)?/i;
		my $show = ucfirst($1);
		my $season = uc($3);
		$show =~ s/\./ /g;
		$show =~ s/aa/å/g;
		$show =~ s/Aa/Å/g;
		$season =~ s/^0//;
		
		#print $show."\n".$season."\n";

		if ($season && $show) {
			unless (-d $folder."/".$show) {
				mkdir $folder."/".$show;
				mkdir $folder."/".$show."/Sesong ".$season;
			}
			unless (-d $folder."/".$show."/Sesong ".$season) {
				mkdir $folder."/".$show."/Sesong ".$season;
			}
			my $command = `mv "$file" "$folder/$show/Sesong $season/$bname"`;
			print $folder."/".$show."/Sesong ".$season."/";
		} else {
			#move($file, $ufolder."/".$bname);
			my $command = `mv "$file" "$ufolder/$bname"`;
			print $ufolder;
		}

	} else {
		#print	
	}
} elsif ($ARGV[$#ARGV] eq "FILM") {
        $file =~ s/ FILM$//;
        #print $file."\n";

        my $is_hd = 0;

        if ((-d $file) || (-e $file)) {
                my $bname = basename($file);
                #print $bname."WAT\n";
                foreach (@hd_tags) {
                        if ($bname =~ m/$_/i) {
                                $is_hd = 1;
                        }
                }

                if ($is_hd) {
                        $folder = $fhdfolder;
                } else {
                        $folder = $fsdfolder;
                }

                my $command = `mv "$file" "$folder/$bname"`;
		print $folder;

	}

} else {
	$file =~ s/ $//;
	if (-d $file) {
		my $bname = basename($file);
		$file =~ s/\/$bname//;
		print "$file";
	} else {
		print "$file";
	}
}
