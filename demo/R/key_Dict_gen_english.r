###############################################################
#### input: dat_seq �ֺôʵ����Ͽ�###############################
####        Nkey �ʵ����ÿ��ؼ��ʵĸ�������� ###################
#### output: �ʵ�ʹ�����         ###############################


	key_Dict_gen_english <- function (dat_seq,label,Nkey,wlen=5)
	{
		source("r_code/word_Highfreq_extract_english.r")
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
			tmpkey[[i]] <- word_Highfreq_extract_english(tmpDat[[i]],pkey,wlen)
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
