use Test::More tests => 4; # -*- mode: cperl -*-
use Git;
use File::Slurp::Tiny qw(write_file);

use lib qw(../lib lib );

BEGIN {
  use_ok( 'Git::Repo::Commits' );
}

# Create test repo
mkdir "test-repo";
chdir "test-repo";
Git::command_oneline( 'init' );
Git::command_oneline( 'config','user.email','jj@merelo.net' );
Git::command_oneline( 'config','user.name','JJ' );
my $repo = Git->repository (Directory => '.');
write_file("one","one");
$repo->command_oneline( 'add', 'one' );
$repo->command_oneline( 'commit', '-am', "First" );
write_file("two","two");
$repo->command_oneline( 'add', 'two' );
write_file("one","one\none");
$repo->command_oneline( 'commit', '-am', "Second" );

# Now the real thing
my $commits = new Git::Repo::Commits ".";
ok ($commits, "Object created");
my @commit_array = @{$commits->commits()};
is( $#commit_array, 1, "Correct number of commits");
is ( @{$commit_array[1]->{'files'}}, 2, "Commit info correct");

diag( "Testing Git::Repo::Commits $Git::Repo::Commits::VERSION" );
