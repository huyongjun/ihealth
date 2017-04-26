############ re : input matrix data 
############ output high freq words
	
	word_Highfreq_extract <- function (re,alfa=0.1,wordmax=3)
	{
		words <- re
		names(words) <- NULL
	# 统计词频
		words_freq <- sort(table(words))
		words_names <- names(words_freq)
		words_length <- nchar(words_names)
	# 加载搜狗实验室的词频文件
		SogouLabDic <- read.table('中文词库/SogouW/Freq/SogouLabDic.dic', fill=T, head=F)
		words_df <- data.frame(words_names=words_names, words_freq=words_freq, words_length=words_length)
	# 只做二、三个字的词
		words_df <- words_df[words_df$words_length %in% c(2:wordmax), ]
		names(SogouLabDic)[1] <- 'words_names'
		SogouLabDic <- SogouLabDic[SogouLabDic[,1] %in% words_df$words_names, ]		
		words_df2 <- merge (words_df, SogouLabDic, by='words_names', all.x=T)
	# 筛选名词和动词。
		words_df2 <- words_df2[grep('^[NV],$',words_df2$V3), ]
	# 挑选前10%为关键词
		l_key <- dim(words_df2)[1]
		l_key <- ceiling(l_key*alfa)
		words_df2_order <- words_df2[order(-words_df2$words_freq), ][1:l_key, ]
		words_df2_order
	}
	
	



	
	