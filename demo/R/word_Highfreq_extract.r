############ re : input matrix data 
############ output high freq words
	
	word_Highfreq_extract <- function (re,alfa=0.1,wordmax=3)
	{
		words <- re
		names(words) <- NULL
	# ͳ�ƴ�Ƶ
		words_freq <- sort(table(words))
		words_names <- names(words_freq)
		words_length <- nchar(words_names)
	# �����ѹ�ʵ���ҵĴ�Ƶ�ļ�
		SogouLabDic <- read.table('���Ĵʿ�/SogouW/Freq/SogouLabDic.dic', fill=T, head=F)
		words_df <- data.frame(words_names=words_names, words_freq=words_freq, words_length=words_length)
	# ֻ�����������ֵĴ�
		words_df <- words_df[words_df$words_length %in% c(2:wordmax), ]
		names(SogouLabDic)[1] <- 'words_names'
		SogouLabDic <- SogouLabDic[SogouLabDic[,1] %in% words_df$words_names, ]		
		words_df2 <- merge (words_df, SogouLabDic, by='words_names', all.x=T)
	# ɸѡ���ʺͶ��ʡ�
		words_df2 <- words_df2[grep('^[NV],$',words_df2$V3), ]
	# ��ѡǰ10%Ϊ�ؼ���
		l_key <- dim(words_df2)[1]
		l_key <- ceiling(l_key*alfa)
		words_df2_order <- words_df2[order(-words_df2$words_freq), ][1:l_key, ]
		words_df2_order
	}
	
	



	
	