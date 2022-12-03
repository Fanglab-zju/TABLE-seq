fasta="/share/home/fanglab/tangyin/data/hg19/hg19.fa"
gtf="/share/home/fanglab/tangyin/data/hg19/hg19.refGene.gtf"
hgtxt="/share/home/fanglab/tangyin/data/hg19/hg19.chrom.sizes.txt"


#loadGenome.pl -name hg19 -org human -fasta $fasta -gtf $gtf

for file in TABLEseq.sorted.bam dUTP.sorted.bam
do
        name=${file%%.sorted.bam}
        samtools view -h $file > $name.sam
makeTagDirectory $name/ -genome hg19 -format sam -sspe -checkGC $name.sam
makeUCSCfile $name/ -o bedGraph/${name}-.bedGraph -strand -
makeUCSCfile $name/ -o bedGraph/${name}+.bedGraph -strand +
gunzip bedGraph/${name}-.bedGraph.gz
gunzip bedGraph/${name}+.bedGraph.gz
sed -i '1d' bedGraph/${name}-.bedGraph
sed -i '1d' bedGraph/${name}+.bedGraph
sort -k1,1 -k2,2n bedGraph/${name}-.bedGraph > bedGraph/${name}-.sorted.bedGraph
# conver bedgraph to bigwig
bedGraphToBigWig bedGraph/${name}-.sorted.bedGraph $hgtxt bedGraph/${name}-.bw
#rm bedGraph/${name}-.sorted.bedGraph
sort -k1,1 -k2,2n bedGraph/${name}+.bedGraph > bedGraph/${name}+.sorted.bedGraph
        # conver bedgraph to bigwig
bedGraphToBigWig bedGraph/${name}+.sorted.bedGraph $hgtxt bedGraph/${name}+.bw
annotatePeaks.pl tss hg19 -size 4000 -hist 10 -pc 3 -d ${name}/ > ${name}.output.txt
done
