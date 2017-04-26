############ re : input matrix data 
############ output high freq words
###  2013-5-6 修改,增加了对名词和动词的筛选
	
	word_Highfreq_extract_english <- function (re,alfa=0.1,wordmax=15)
	{
		words <- re
		names(words) <- NULL
	# 统计词频
		words_freq <- sort(table(words))
		words_names <- names(words_freq)
		words_length <- nchar(words_names)
	# 加载搜狗实验室的词频文件
		#SogouLabDic <- read.table('中文词库/SogouW/Freq/SogouLabDic.dic', fill=T, head=F)
		words_df <- data.frame(words_names=words_names, words_freq=words_freq, words_length=words_length)
	# 只做二、三个字的词
		words_df <- words_df[words_df$words_length %in% c(2:wordmax), ]
		#names(SogouLabDic)[1] <- 'words_names'
		#SogouLabDic <- SogouLabDic[SogouLabDic[,1] %in% words_df$words_names, ]		
		#words_df2 <- merge (words_df, SogouLabDic, by='words_names', all.x=T)
	
	# 挑选前10%为关键词
		l_key <- dim(words_df)[1]
		l_key <- ceiling(l_key*alfa)
		words_df2_order <- words_df[order(-words_df$words_freq), ]
		words_df2_order
		
	# 筛选名词和动词。
		#words_df2 <- words_df2[grep('^[NV],$',words_df2$V3), ]
		source("r_code/filter_NV_eng.r")
	
		tt <- as.matrix(words_df2_order$words_names)
		#buf <- filter_NV_eng(tt)
		buf <- tt

		buf_def <- data.frame(words_names=names(sort(table(buf))),
			words_freq=sort(table(buf)))
		buf_def2 <- merge (buf_def,words_df2_order, by='words_names', 
			all.x=T)
		if(l_key <= nrow(buf_def2))
			buf_df2_order <- buf_def2[order(-buf_def2$words_freq.y), ][1:l_key, ]
		else
			buf_df2_order <- buf_def2[order(-buf_def2$words_freq.y), ]
		#buf_df2_order
		words_df2_order[1:l_key, ] ##不过滤词性
	}
	
	



	
	