###############################################################
#### input: dat_seq 分好词的语料库###############################
####        Nkey 词典包含每类关键词的个数或比率 ###################
#### output: 词典和词条名         ###############################

	key_Dict_gen <- function (dat_seq,label,Nkey,wlen=5)
	{
		source("r_code/word_Highfreq_extract.r")
		library(rmmseg4j)
		library(tm)

		classes <- label
		cl <- length(table(classes))
		CLS <- as.numeric(names(table(classes)))
		roleDat <- tmpDat <- tmpkey <- list()

		if(Nkey <= 1) pkey <- Nkey
		else pkey <- 1
		

		for(i in 1:cl)
		{
			roleDat[[i]] <- dat_seq[classes==CLS[i]]
			tmpDat[[i]] <- unlist(strsplit(roleDat[[i]]," "))
			tmpkey[[i]] <- word_Highfreq_extract(tmpDat[[i]],pkey,wlen)
		}

		if(Nkey > 1)
		{
			for(i in 1:cl)
			{
				Nkey <- ceiling(Nkey)
				tmpkey[[i]] <- tmpkey[[i]][1:Nkey,]
			}
		}
		## cl >= 2
		tt <- merge(tmpkey[[1]], tmpkey[[2]], by='words_names', all=TRUE)
		names_key <- tt
		tt <- tt['words_names']
		for(i in 1:cl)
		{
			if(i > 2)
			{
				tt <- merge (tt, tmpkey[[i]], by='words_names', all=TRUE)
				names_key <- tt
				tt <- tt['words_names']
			}
		}

		
		key <- tt['words_names']

		c_words <- Corpus(DataframeSource(key))
		n_words <- length(c_words)
		re_tmp <- c_words[[1]]
		for(i in 1:n_words)
		{
			if(i>1) re_tmp <- paste(re_tmp,c_words[[i]],sep=" ")

		}
		dict <- Dictionary(unlist(strsplit(re_tmp,' ')))
		result <- list(dict=dict,key=tmpkey,names=names_key,Length=nrow(names_key))
		result
	}
