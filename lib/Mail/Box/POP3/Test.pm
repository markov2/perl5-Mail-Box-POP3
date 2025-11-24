#oodist: *** DO NOT USE THIS VERSION FOR PRODUCTION ***
#oodist: This file contains OODoc-style documentation which will get stripped
#oodist: during its release in the distribution.  You can use this file for
#oodist: testing, however the code of this development version may be broken!

package Mail::Box::POP3::Test;
use base 'Exporter';

use strict;
use warnings;

use Log::Report  'mail-box-pop3';

use List::Util    qw/first/;
use File::Spec    ();

use Mail::Transport::POP3 ();

our @EXPORT = qw/start_pop3_server start_pop3_client/;

#
# Start POP3 server for tests
#

sub start_pop3_server($;$)
{	my $popbox  = shift;
	my $setting = shift || '';

	my $serverscript = File::Spec->catfile('t', 'server');

	# Some complications to find-out $perl, which must be absolute and
	# untainted for perl5.6.1, but not for the other Perl's.
	my $perl   = $^X;
	unless(File::Spec->file_name_is_absolute($perl))
	{	my @path = split /\:|\;/, $ENV{PATH};
		$perl    = first { -x $_ } map File::Spec->catfile($_, $^X), @path;
	}

	$perl =~ m/(.*)/;
	$perl = $1;
	%ENV = ();

	open my $server, "$perl $serverscript $popbox $setting |"
		or fault __x"could not start POP3 test server";

	my $line  = <$server>;
	my $port  = $line =~ m/(\d+)/ ? $1 : error __x"did not get port specification, but '{text}'.", text => $line;

	($server, $port);
}

#
# START_POP3_CLIENT PORT, OPTIONS
#

sub start_pop3_client($@)
{	my ($port, @options) = @_;

	Mail::Transport::POP3->new(
		hostname => '127.0.0.1',
		port     => $port,
		username => 'user',
		password => 'password',
		@options,
	);
}

1;
