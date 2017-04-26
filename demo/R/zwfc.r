	zwfc <- function (text,zj)
	{
		.jinit("ÎÄ±¾ÍÚ¾ò/hzfc.jar")
		hjw <- .jnew("org.apache.lucene.analysis.cn.hzfc")
	
		outRef <- .jcall(hjw, "S" , "txtMethod",text,zj, evalString = FALSE)
		result   <- .jstrVal(outRef)
		result
	}