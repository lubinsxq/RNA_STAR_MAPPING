#!/bin/bash
#$ -cwd
#$ -v PATH,LD_LIBRARY_PATH,CLASSPATH
#$ -l m_mem_free=10G
#$ -l tmp_free=50G

 Human=/grid/mills/home/xsun/index_file/HISAT2/hg38_Index/hg38/hg38
 Mouse=/grid/mills/home/xsun/index_file/HISAT2/mm10_Index/mm10/mm10
 mkdir ./summary

 for i in XS-7*R1*val_1.fq.gz
 do
         echo $i
         R2=${i/R1_001_val_1/R2_001_val_2}
         echo $R2
         name=${i/_R1_001_val_1.fq.gz/}
         echo $name
         hisat2  -p 16 --no-mixed --no-unal --no-spliced-alignment --no-unal  --no-discordant --phred33  -x $Mouse   -1 $i -2 $R2 -S ${name}_ht2_snstv.sam --summary-file ./summary/${name}.summary.txt 
         samtools view -bS  ${name}_ht2_snstv.sam > ${name}_ht2_snstv.bam
         samtools sort ${name}_ht2_snstv.bam -o ${name}_ht2_snstv.sorted.bam
         rm ${name}_ht2_snstv.bam
         samtools rmdup -s ${name}_ht2_snstv.sorted.bam ${name}_ht2_snstv.sorted.rd.bam
         samtools index ${name}_ht2_snstv.sorted.rd.bam
         rm ${name}_ht2_snstv.sorted.bam
 done
