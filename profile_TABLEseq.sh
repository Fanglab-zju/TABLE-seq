fasta="/share/home/fanglab/tangyin/data/mm9/mm9.fa"
gtf="/share/home/fanglab/tangyin/data/mm9/mm9.refGene.gtf"
mmtxt="/share/home/fanglab/tangyin/data/mm9/mm9.chrom.sizes.txt"


#loadGenome.pl -name mm9 -org mouse -fasta $fasta -gtf $gtf

for file in TABLEseq.sorted.bam dUTP.sorted.bam
do
        name=${file%%.sorted.bam}
        samtools view -h $file > $name.sam
makeTagDirectory $name/ -genome mm9 -format sam -sspe -checkGC $name.sam
makeUCSCfile $name/ -o bedGraph/${name}-.bedGraph -strand -
makeUCSCfile $name/ -o bedGraph/${name}+.bedGraph -strand +
gunzip bedGraph/${name}-.bedGraph.gz
gunzip bedGraph/${name}+.bedGraph.gz
sed -i '1d' bedGraph/${name}-.bedGraph
sed -i '1d' bedGraph/${name}+.bedGraph
sort -k1,1 -k2,2n bedGraph/${name}-.bedGraph > bedGraph/${name}-.sorted.bedGraph
# conver bedgraph to bigwig
bedGraphToBigWig bedGraph/${name}-.sorted.bedGraph $mmtxt bedGraph/${name}-.bw
#rm bedGraph/${name}-.sorted.bedGraph
sort -k1,1 -k2,2n bedGraph/${name}+.bedGraph > bedGraph/${name}+.sorted.bedGraph
        # conver bedgraph to bigwig
bedGraphToBigWig bedGraph/${name}+.sorted.bedGraph $mmtxt bedGraph/${name}+.bw
annotatePeaks.pl tss mm9 -size 4000 -hist 10 -pc 3 -d ${name}/ > ${name}.output.txt
done
