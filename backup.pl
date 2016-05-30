#!/usr/bin/perl
use DBI;
use strict;
use Time::Piece;
my $time = Time::Piece->new;

###
# Initial database config
###
my $driver = "mysql"; 
my $database = "sudoers_drive";
my $dsn = "DBI:$driver:database=$database";
my $userid = "owncloud_backup";
my $password = "fITw2HHImBmEmKmo";

###
# Initial variable
###
my $date_folder = $time->strftime('%Y_%m_%d');

#print $time."\n";
###
# Initial file directory
##

my $source_backup = "/var/owncloud/data/";
my $destination_backup = "/var/backup/";
my $dbh = DBI->connect($dsn, $userid, $password ) or die $DBI::errstr;
my $sth = $dbh->prepare("SELECT uid,password FROM oc_users");
$sth->execute() or die $DBI::errstr;

while (my @row = $sth->fetchrow_array()) {
   my ($uid, $password ) = @row;
   #print "Username = $uid, Password = $password\n";
   if (-d $source_backup.$uid){
       unless(mkdir $destination_backup.$uid) { 
       #die "Unable to create $destination_backup$uid\n";}
            system("rsync", "-av", $source_backup.$uid."/files/", $destination_backup.$uid."/$date_folder");
       }
   }
}
