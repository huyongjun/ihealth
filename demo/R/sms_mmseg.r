############ txtTable : table��ʽ��ԭʼԤ��
############ n: Ԥ�ϳ���
############ output: �ִʴ���������Ԥ��
	sms_mmseg <- function (txtTable,n)
	{
##### �����ַ������������ݽ��з���
		library(Snowball)
		library(rmmseg4j)
		reuters <- Corpus(VectorSource(txtTable))
############## ���ķִ� ######################
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