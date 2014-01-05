#!/usr/bin/perl
# script finds  the largest table in use
#  
#

my $MyDatabase=$ARGV[$0];


$command="mysql -u commander -pcommander -e 'use database $myDatabase;show tables;'";
my @my_tables=`$command`;
my $maxElement=0;
my $currentElement;
my $tableName;

for my $table (@my_tables)
{

   chomp($table);
   $query = <<EOL;
   mysql -u commander -pcommander -e "use information_schema;
   select round((((index_length + data_length)/1024)/1024)/1024) as capacity  from tables where table_name='$table' and TABLE_SCHEMA='$MyDatabase' ;"
EOL
   chomp($currentElement=`$query`);
   $currentElement=~ s/capacity//;
   if($currentElement>$maxElement)
   {
     $tableName=$table;
     $maxElement=$currentElement;
  }
}

print $tableName."=".$maxElement."GB\n";
