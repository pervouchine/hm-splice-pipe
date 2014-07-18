hm-splice-pipe
==============

Human-Mouse comparative splicing pipeline

==============

Pipeline description to follow

Provided below is the description of the two main endpoints:
 * bidirectional unique map between human and mouse exon boundaries
 * bidirectional unique map between human and mouse segments (exons or introns)

==============

The following two tab-delimited files contain correspondence between human and mouse exon boundaries and segments (exons and introns)

* hg19.mm9.bum_s.tab -- bidirectional unique map between human and mouse exon boundaries 
  The columns 1-7 are for human; columns 8-14 are for mouse:
  1) chr_pos_strand = boundary coordinate in the genome (the coordinate is always of the first or the last exonic nucleotide)
  2) boundary_type (5 or 3, 5 = 5'-exon-boundary = acceptor site or start; 3 = 3' exon boundary = donor site or end)
  3) gene_id
  4) gene_class (for the integrative mouse paper) 
  5) position_within_transcript (1=initial, 2=internal, 3=terminal)
  6) prediction_level (0=predicted from RNA-seq, 1=annotated)
  7) alternative_status (0=alternative, 1=constitutive)
  8-14) contain the same information as 1-7 but in mouse


* hg19.mm9.bum_r.tab -- bidirectional unique map between human and mouse segments (exons or introns)
  The columns are:
  1) chr_beg_end_strand = segment coordinate in the genome. 
	Note that (i) if strand < 0 then beg > end, and 
		 (ii) positions always refer to the first or the last exonic nucleotide, also for introns 
  2) segment_type (1=exon, 2=intron)
  3) gene_id
  4) gene_class
  5) position_within_transcript (1=initial, 2=internal, 3=terminal)
  6) prediction_level (0=predicted from SJ, 1=annotated); note that only introns but not exons can be predicted from SJ
  7) alternative_status (0=alternative, 1=constitutive)
  8-14) contain the same information as 1-7 but in mouse
  15) mapping_status (0 = annotated in both, -1 = predicted in human by mouse support, 1 = predicted in mouse by human support)

For instance, in order to get the orthologous list of annotated exons, do 
   awk '$2==1 && $15==0' data/hg19.mm9.bum_r.tab

