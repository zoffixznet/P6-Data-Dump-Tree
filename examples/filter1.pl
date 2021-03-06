use Data::Dump::Tree ;
use Data::Dump::Tree::ExtraRoles ;
use Terminal::ANSIColor ;

my $s =
	[
	123,
	{
		first => [ < a b c > ],
		second => < a b c >,
		third => { a => 1, b => 2,},
	},
	Int,
	1.234,
	] ;

class Tomatoe{}
class Potatoe{}

my $s2 =
	[
	Tomatoe,
	123,
	Tomatoe,
	Potatoe,
	{
		third => { a => 1},
	},
	0.5,
	Tomatoe,
	] ;


my $d = Data::Dump::Tree.new ;
$d does DDTR::QuotedString ;

multi sub my_filter(\s_replacement, Int $s, DDT_HEADER, ($depth, $glyph, @renderings), (\k, \b, \v, \f, \final, \want_address))
{
#@renderings.append: $glyph ~ color('bold white on_yellow') ~ "Int HEADER " ~ $depth ;

if $depth < 3 
	{
	s_replacement = { a => 'str', nothing => Data::Dump::Tree::Type::Nothing, b => 1 }  ;

	k = k ~ ' wil be replaced by Hash ' ;
	#b = '' ;
	#v = '' ;
	#f = '' ;
	final = DDT_NOT_FINAL ;
	want_address = True ;
	}
}

multi sub my_filter($r, $s, DDT_HEADER, ($depth, $glyph, @renderings), ($k, $b, $v, $f, $final, $want_address))
{
#@renderings.append: $glyph ~ "HEADER " ~ $k ~ $b ~ " - " ~ ($v // $v.^name) ~ " - " ~ $f ~ ' - @depth' ~ $depth ;
}

multi sub my_filter(\r, Tomatoe $s, DDT_HEADER, ($depth, $glyph, @renderings), $)
{
@renderings.append: color('red') ~ 'removing tomatoe' ;
r = Data::Dump::Tree::Type::Nothing ;
}

multi sub my_filter(Hash $s, DDT_SUB_ELEMENTS, ($depth, $glyph, @renderings), (@sub_elements))
{
#@renderings.append: $glyph ~ "SUB ELEMENTS" ;
@sub_elements = (('key', ': ', 'value'), ('other_key', ': ', 1)) ; 
}

multi sub my_filter($s, DDT_FOOTER, ($depth, $filter_glyph, @renderings))
{
#@renderings.append: $filter_glyph ~ "FOOTER for {$s.^name}" ;
}

#$d.dump($s, filters => (&my_filter)) ;
$d.dump($s2) ;
$d.dump($s2, filters => (&my_filter)) ;


