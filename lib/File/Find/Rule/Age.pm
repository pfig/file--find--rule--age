package File::Find::Rule::Age;

use strict;
use warnings;

use File::Find::Rule;
use base qw( File::Find::Rule );
use vars qw( $VERSION @EXPORT );
@EXPORT  = @File::Find::Rule::EXPORT;
$VERSION = "0.2"; 

use DateTime;
use File::stat;

sub File::Find::Rule::age {
    my $self = shift()->_force_object;
    
    my ( $criterion, $age ) = @_;
        
    my ( $interval, $unit ) = ( $age =~ /^(\d+)([DWMYhms])$/ );
    if ( ! $interval or ! $unit ) {
        return;
    } else {
        my %mapping = (
            "D" => "days",
            "W" => "weeks",
            "M" => "months",
            "Y" => "years",
            "h" => "hours",
            "m" => "minutes",
            "s" => "seconds", );
        $self->exec( sub {
                         my $dt = DateTime->now;
                         $dt->subtract( $mapping{$unit} => $interval );
                         my $compare_to = $dt->epoch;
                         my $mtime = stat( $_ )->mtime;
                         return $criterion eq "older" ?
                            $mtime < $compare_to :
                            $mtime > $compare_to;
                     } );
    }
}

1;
__END__

=head1 NAME

File::Find::Rule::Age - rule to match on file age

=head1 SYNOPSIS

    use File::Find::Rule::Age;
    my @old_files = find( file => age => [ older => '1M' ], in => '.' );
    my @today     = find( file => age => [ newer => '1D' ], in => '.' );

=head1 DESCRIPTION

File::Find::Rule::Age makes it easy to search for files based on their age.
DateTime and File::stat are used to do the behind the scenes work, with
File::Find::Rule doing the Heavy Lifting.

By 'age' I mean 'time elapsed since mtime' (the last time the file was
modified).

=head1 FUNCTIONS

=head2 ->age( [ $criterion => $age ] )

$criterion must be one of "older" or "newer".
$age must match /^(\d+)([DWMYhms])$/ where D, W, M, Y, h, m and s are "day(s)",
"week(s)", "month(s)", "year(s)", "hour(s)", "minute(s)"  and "second(s)",
respectively - I bet you weren't expecting that.

=head1 AUTHOR

Pedro Figueiredo, C<< <pedro.figueiredo at sns.bskyb.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-find-find-rule-age at rt.cpan.org>, or through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Find-Find-Rule-Age>.  I will be notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Find::Find::Rule::Age


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Find-Find-Rule-Age>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Find-Find-Rule-Age>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Find-Find-Rule-Age>

=item * Search CPAN

L<http://search.cpan.org/dist/Find-Find-Rule-Age>

=back

=head1 ACKNOWLEDGEMENTS

Richard Clamp, the author of File::Find::Rule, for putting up with me.

=head1 COPYRIGHT

Copyright (C) 2008 Sky Network Services. All Rights Reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 SEE ALSO

L<File::Find::Rule>, L<DateTime>, L<File::stat>

=cut
