############ txtTable : table格式的原始预料
############ n: 预料长度
############ output: 分词处理后的中文预料
	sms_mmseg <- function (txtTable,n)
	{
##### 采用字符向量导入数据进行分析
		library(Snowball)
		library(rmmseg4j)
		reuters <- Corpus(VectorSource(txtTable))
############## 中文分词 ######################
		reuters <- tm_map(reuters, stripWhitespace)
#############################################
		re <- 0
		for (i in 1:n) 
		{
    			re[[i]]<- mmseg4j(as.character(reuters[[i]]))
    		}
		reuters <- Corpus(VectorSource(re))
		reuters
	}