sub uniq {
    my %f = ();
    foreach $z(@_) {
        $f{$z}=1 if($z);
    }
    return(sort keys(%f));
}

$SITE_ACC = 5;
$SITE_DON = 3;

$SEGM_EXON = 1;
$SEGM_INTR = 2;

$POS_INIT = 1;
$POS_INTL = 2;
$POS_TERM = 3;
$POS_UNDF = 0;

$LEV_CONF = 1;
$LEV_PRED = 0;


$STATUS_121 = 0;
$STATUS_12X = 1;
$STATUS_X21 = -1;

%BIOTYPE_SHORT = split /[\t\n]/, `cut -f1,2 biotypes.dat`;
@BIOTYPES = uniq split /\n/, `cut -f2 biotypes.dat`;

sub GET_BIOTYPE {return($BIOTYPE_SHORT{@_[0]} ? $BIOTYPE_SHORT{@_[0]} : "other");}


%annotation = ( 'hg19',         'http://genome.crg.eu/~dmitri/export/annotation/gen10.long.gncat.gtf.gz',
                'mm9',          'http://genome.crg.eu/~dmitri/export/annotation/mm65+lincRNA+pseudogenes.long.gncat.gtf.gz'
         );

%import = (     'hg19',         'http://genome.crg.es/~dmitri/export-2.2/hg19/',
                'mm9',          'http://genome.crg.es/~dmitri/export-2.2/mm9/');

%genome = (     'hg19',         'http://genome.crg.es/~dmitri/export-2.2/hg19/hg19',
                'mm9',          'http://genome.crg.es/~dmitri/export-2.2/mm9/mm9'
        );

%sname = (      'hg19',         'Human',
                'mm9',          'Mouse'
         );



return(1);

