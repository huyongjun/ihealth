######################################################################
####### 1. lda 模型训练          ################################
from nltk.tokenize import RegexpTokenizer
from stop_words import get_stop_words
from nltk.stem.porter import PorterStemmer
from gensim import corpora, models
import gensim

tokenizer = RegexpTokenizer(r'\w+')

# create English stop words list
en_stop = get_stop_words('en')

# Create p_stemmer of class PorterStemmer
p_stemmer = PorterStemmer()
    
# create sample documents
doc_a = "Brocolli is good to eat. My brother likes to eat good brocolli, but not my mother."
doc_b = "My mother spends a lot of time driving my brother around to baseball practice."
doc_c = "Some health experts suggest that driving may cause increased tension and blood pressure."
doc_d = "I often feel pressure to perform well at school, but my mother never seems to drive my brother to do better."
doc_e = "Health professionals say that brocolli is good for your health." 

# compile sample documents into a list
doc_set = [doc_a, doc_b, doc_c, doc_d, doc_e]

# list for tokenized documents in loop
texts = []

# loop through document list
for i in doc_set:
    # clean and tokenize document string
    raw = i.lower()
    tokens = tokenizer.tokenize(raw)
    # remove stop words from tokens
    stopped_tokens = [i for i in tokens if not i in en_stop]
    # stem tokens
    stemmed_tokens = [p_stemmer.stem(i) for i in stopped_tokens]
    # add tokens to list
    texts.append(stemmed_tokens)

# turn our tokenized documents into a id <-> term dictionary
dictionary = corpora.Dictionary(texts)
    
# convert tokenized documents into a document-term matrix
corpus = [dictionary.doc2bow(text) for text in texts]

# generate LDA model
ldamodel = gensim.models.ldamodel.LdaModel(corpus, num_topics=2, id2word = dictionary, passes=20)

####
print(ldamodel.print_topics(num_topics=3, num_words=3))


############################################################################
### 2. 词频统计等相关分析  #####################################################
from gensim import corpora, models, similarities

tfidf = models.TfidfModel(corpus)
corpus_tfidf = tfidf[corpus]
lsi = models.LsiModel(corpus_tfidf, id2word=dictionary, num_topics=10)
index = similarities.MatrixSimilarity(lsi[corpus])

ml_bow = dictionary.doc2bow(texts[1])
ml_lsi = lsi[ml_bow]
print ml_lsi

sims = index[ml_lsi]
sort_sims = sorted(enumerate(sims), key=lambda item: -item[1])
print sort_sims[0:3]
print texts[1]
print texts[3]
print texts[0]

######################################################################################
## 2.1. tfidf by sensim
tfidf = models.TfidfModel(corpus)
print(tfidf[ml_bow])
tfidf.save('/home/hyj/data/foo.tfidf_model')

english_punctuations = [',', '.', ':', ';', '?', '(', ')', '[', ']', '&', '!', '*', '@', '#', '$', '%']

# (1) Gensim也包含高效的实用函数来帮助从/向 numpy矩阵转换
numpy_matrix = gensim.matutils.corpus2dense(corpus)
corpus = gensim.matutils.Dense2Corpus(numpy_matrix)

#(2) 以及从/向 scipy.sparse 矩阵转换
scipy_sparse_matrix = gensim.matutils.corpus2csc(corpus)
corpus = gensim.matutils.Sparse2Corpus(scipy_sparse_matrix)

##########################################################################
#2.2 CountVectorizer by sklearn
# coding:utf-8
from sklearn.feature_extraction.text import CountVectorizer
#将文本中的词语转换为词频矩阵
vectorizer = CountVectorizer()
#计算个词语出现的次数
X = vectorizer.fit_transform(doc_set)

#获取词袋中所有文本关键词
word = vectorizer.get_feature_names()
print word

#查看词频结果
print X.toarray()

#(1) TfidfTransformer
from sklearn.feature_extraction.text import TfidfTransformer

#类调用
transformer = TfidfTransformer()
print transformer

#将词频矩阵X统计成TF-IDF值
tfidf = transformer.fit_transform(X)

#查看数据结构 tfidf[i][j]表示i类文本中的tf-idf权重
print tfidf.toarray()