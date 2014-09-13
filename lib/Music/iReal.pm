package Music::iReal;

use 5.014002;
use strict;
use warnings;

use Carp;

use URI::Encode qw(uri_encode uri_decode);

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw() ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

our $VERSION = '0.01';

my %TIME_SIGNATURES = qw(
    4/4     T44
);

my %TRANSPOSE;

{
    no warnings;
    %TRANSPOSE = qw(
        C   0               A-  0
        C#  1   Db  1       A#- 1   Bb- 1
        D   2               B-  2
        D#  3   Eb  3       C-  3
        E   4               C#- 4   Db- 4
        F   5               D-  5
        F#  6   Gb  6       D#- 6   Eb- 6
        G   7               E-  7
        G#  8   Ab  8       F-  8
        A   9               F#- 9   Gb- 9
        A#  10  Bb  10      G-  10
        B   11              G#- 11
        
        Nashville   12
        123         12
    );
}

my @COMP_STYLES = (
    'Jazz-Ballad Swing', 'Jazz-Ballad Even', 'Jazz-Slow Swing', 'Jazz-Medium Swing', 'Jazz-Medium Up Swing', 'Jazz-Up Tempo Swing',
    'Jazz-Double Time Swing', 'Jazz-Swing Two/Four', 'Jazz-Bossa Nova', 'Jazz-Even 8ths', 'Jazz-Latin', 'Jazz-Latin/Swing',
    'Jazz-Afro 12/8', 'Jazz-Gypsy Jazz', 'Jazz-Practice',
    
    'Brazilian-Bossa Electric', 'Brazilian-Bossa Acoustic', 'Brazilian-Samba',
    
    'Cuban-Son Montuno 2-3', 'Cuban-Son Montuno 3-2', 'Cuban-Cha Cha Cha', 'Cuban-Bolero',
    
    'Argentinian-Tango',
    
    'Pop-Rock', 'Pop-Slow Rock', 'Pop-Rock 12/8', 'Pop-Funk', 'Pop-Soul', 'Pop-RnB', 'Pop-Smooth', 'Pop-Disco', 'Pop-Reggae',
    'Pop-Shuffle', 'Pop-Country', 'Pop-Bluegrass',
);

my %COMP_STYLES;
@COMP_STYLES{@COMP_STYLES} = @COMP_STYLES;

my @FIELDS = qw(
    title
    composer
    _unknown1
    style
    key
    transpose
    body
    comping_style
    bpm
    repeats
);

sub new {
    my $class = shift;
    $class = ref($class) || $class;

    my $self = {};
    for my $field (@FIELDS) {
        $self->{$field} = '';
    }

    %$self = (
        %$self,
        title       => 'New Song',
        composer    => 'Composer Unknown',
        style       => 'Medium Swing',
        key         => 'C',
        bpm         => 0,
        repeats     => 0,
    );

    return bless $self, $class;
}

sub export {
    my $self = shift;
    
    my $song = 'irealb://' . join('=', @{ $self }{ @FIELDS });

    return uri_encode($song);
}

sub title       { $_[0]->{title}    = $_[1]; $_[0] }
sub composer    { $_[0]->{composer} = $_[1]; $_[0] }
sub style       { $_[0]->{style}    = $_[1]; $_[0] }

sub key {
    my $self = shift;
    my $key = shift;
    
    if (exists $TRANSPOSE{$key}) {
        $self->{key} = $key;
    }
    else {
        confess "Invalid key '$key'";
    }
    
    return $self;
}

sub comping_style {
    my $self = shift;
    my $style = shift;

    if (exists $COMP_STYLES{$style}) {
        $self->{comping_style} = $style;
    }
    else {
        confess "Unknown comp style '$style'";
    }

    return $self;
}

sub transpose {
    my $self = shift;
    my $key = shift;

    if (exists $TRANSPOSE{$key}) {
        $self->{transpose} = $TRANSPOSE{$key};
    }
    else {
        confess "Unknown transpose key or Nashville '$key'";
    }

    return $self;
}

sub bpm {
    my $self = shift;
    my $bpm = shift;
    if ($bpm =~ /\D/) {
        confess "Invalid BPM (not a number) '$bpm'";
    }
    else {
        $self->{bpm} = $bpm;
    }
    return $self;
}

sub repeat {
    my $self = shift;
    my $repeat = shift;
    if ($repeat =~ /\D/) {
        confess "Invalid repeats (not a number) '$repeat'";
    }
    else {
        $self->{repeat} = $repeat;
    }
    return $self;
}

sub add_time {
    my $self = shift;
    my $time = shift;
    exists $TIME_SIGNATURES{$time}
        or confess "Unknown time signature '$time'";
    $self->{body} .= $TIME_SIGNATURES{$time};
}

1;
