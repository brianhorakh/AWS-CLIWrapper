# -*- mode: cperl -*-
use strict;
use Test::More;

use AWS::CLIWrapper;

my $aws = AWS::CLIWrapper->new;
my $res;

# >= 0.14.0 : Key, Values, Name
# <  0.14.0 : key, values, name, also accept Key, Values, Name
subtest 'Uppercase key, values, name' => sub {
    $res = $aws->ec2('describe-instances', {
        filters => [{ name => 'tag:Name', values => ["AC-TEST-*"] }],
    });
    ok($res);
};

# >= 0.14.0 : --count N or --count MIN:MAX
# <  0.14.0 : --min-count N and --max-count N
subtest 'ec2 run-instances: --min-count, --max-count VS --count' => sub {
    # >= 0.14.0 : fail
    $res = $aws->ec2('run-instances', {
        image_id  => '1',
        min_count => 1,
        max_count => 1,
    });

    ok(!$res); # should fail
    unlike($AWS::CLIWrapper::Error->{Message}, qr/Unknown options:/);

    # <  0.14.0 : fail
    $res = $aws->ec2('run-instances', {
        image_id => '1',
        count    => 1,
    });

    ok(!$res); # should fail
    unlike($AWS::CLIWrapper::Error->{Message}, qr/--(?:min|max)-count is required/);
};

done_testing;