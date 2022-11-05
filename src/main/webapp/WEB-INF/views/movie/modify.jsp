<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../includes/header.jsp" %>

<div id="wrap" align = "center">
	<h1>영화정보 수정</h1>
	<form name="frm" method="post" action="/movie/modify">
		<input type="hidden" name="code" value='<c:out value="${movie.code }"/>'>
		<table>
			<tr>
				<td>
				<div class="showImg">
				<ul>
				
						
				</ul>
				</div>
				</td>
				<td>
					<table>
						<tr>
							<th style="width:80px">제  목</th>
							<td><input type = "text" name ="title" value='<c:out value="${movie.title }"/>' size="80"></td>
						</tr>
						<tr>
							<th>가  격</th>
							<td><input type = "text" name ="price" value='<c:out value="${movie.price }"/>'> 원</td>
						</tr>
						<tr>
							<th>감  독</th>
							<td><input type = "text" name ="director" value='<c:out value="${movie.director }"/>' size="80"></td>
						</tr>
						<tr>
							<th>배  우</th>
							<td><input type = "text" name ="actor" value='<c:out value="${movie.actor }"/>' size="80"></td>
						</tr>
						<tr>
							<th>시놉시스</th>
							<td><textarea rows="10" cols="90" name="synopsis"><c:out value="${movie.synopsis }"/></textarea></td>
						</tr>
						<tr>
							<th>사  진</th>
							<td><div class="form-group uploadDiv">
								<input type="file" name='uploadFile' multiple><br>
								</div>
								<div class="uploadResult">
								<ul>
						
								</ul>
								</div>	
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br>
		<button type="submit" class="btn btn-default" data-oper="modify">수정</button>
		<button type="submit" class="btn btn-default" data-oper="list" >목록</button>
	</form>
</div>

<script type="text/javascript">
$("document").ready(function(){
	
		var formObj = $("form");
		
	$('button').on("click", function(e){
		
		e.preventDefault();
		
		var operation = $(this).data("oper");
		
		console.log(operation);
		
		if(operation === 'list'){
			
			formObj.attr("action", "/movie/list").attr("method", "get");
			formObj.empty();
			
		}else if(operation === 'modify'){
			
			console.log("submit clicked");
			var str = "";
			
			$(".uploadResult ul li").each(function(i,obj){
				
				var jobj = $(obj);
				
				str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
			});
			
			formObj.append(str).submit();
			
		}
		
		formObj.submit();
		
		
	});
});
</script> 

<script type="text/javascript">
$(document).ready(function(){
	(function(){
	
		var code = '<c:out value="${movie.code}"/>';
		
		$.getJSON("/movie/getAttachList", {code:code}, function(arr){
			console.log(arr);
			
			var str="";
			
			$(arr).each(function(i,attach){
				
			var fileCallPath = encodeURIComponent(attach.uploadPath.replace(/\\/g, '/')+"/s_"+attach.uuid+"_"+attach.fileName);
			
			str += "<li style='list-style:none;' data-path='"+attach.uploadPath+"'";
			str += " data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'";
			str += " ><div>";
			str += "<img src='/display?fileName="+fileCallPath+"'>";
			str += "</div>";
			str + "</li>";	
			
			});
			
			$(".showImg ul").html(str);
			
		});//end getjson
	})();//end function
	
	$(".uploadResult").on("click", "button", function(e){
		
		console.log("delete file");
		
		if(confirm("Remove this file? ")){
			
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			
			var targetLi = $(this).closest("li");
			
			$.ajax({
				
				url:'/deleteFile',
				data:{fileName: targetFile, type: type},
				dataType:'text',
				type:'POST',
				success : function(result){
					
					alert(result);
					targetLi.remove();
				}
				
			});
		}
	});
	

	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880;//5MB
	
	function checkExtension(fileName, fileSize){
		if(fileSize >= maxSize){
			alert("파일 사이즈 초과");
			return false;
		}
		
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드 할 수 없습니다.");
			return false;
		}
		
		return true;
	}
	
	$("input[type='file']").change(function(e){
		
		var formData = new FormData();
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;
		
		for(var i=0; i<files.length; i++){
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			
			formData.append("uploadFile", files[i]);
		}
		
		$.ajax({
			
			url:'/uploadAjaxAction',
			processData: false,
			contentType:false,
			data: formData,			
			type:'POST',
			dataType:'json',
			success:function(result){
				console.log(result);
				showUploadFile(result);
			}
		});
	});
	
	function showUploadFile(uploadResultArr){
		if(!uploadResultArr || uploadResultArr.length == 0){
			
			return;
		}
		
		var uploadURL = $(".uploadResult ul");
		var str ="";
		
		var obj = uploadResultArr[0];
		
		var fileCallPath=encodeURIComponent(obj.uploadPath.replace(/\\/g, '/')+"/s_"+obj.uuid +"_"+obj.fileName);
        str += "<li style='list-style:none;' data-path='"+obj.uploadPath+"'";
        str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
        str +=" ><div>";
        str += "<button type='button' data-file=\'"+fileCallPath+"\' "
        str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
        str += "<img src='/display?fileName="+fileCallPath+"'>";
        str += "</div>";
        str +"</li>";
	
		uploadURL.append(str);
	}
	
		

	
	
});
</script>
<%@ include file="../includes/footer.jsp" %>