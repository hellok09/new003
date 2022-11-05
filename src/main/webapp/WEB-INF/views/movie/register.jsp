<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../includes/header.jsp" %>

<div id="wrap" align = "center">
		<h1>영화정보등록</h1>
		<form role="form" name="form" method="post" action="/movie/register" >
			<table>
				<tr>
					<th>제  목</th>
					<td><input type = "text" name ="title" size="60"></td>
				</tr>
				<tr>
					<th>가  격</th>
					<td><input type = "text" name ="price" size="60"> 원</td>
				</tr>
				<tr>
					<th>감  독</th>
					<td><input type = "text" name ="director" size="60"></td>
				</tr>
				<tr>
					<th>배  우</th>
					<td><input type = "text" name ="actor" size="60"></td>
				</tr>
				<tr>
					<th>설	명</th>
					<td><textarea rows="10" cols="70" name="synopsis"></textarea></td>
				</tr>
				<tr>
					<th>사  진</th>
					<td>
					<div class="form-group uploadDiv">
					<input type="file" name='uploadFile' multiple><br>
					</div>
						<div class="uploadResult">
						<ul>
						
						</ul>
						</div>	
					</td>
				</tr>
			</table>
			<br>
			<button type="submit" class="btn btn-default" data-oper="register">확인</button>
			<button type="reset" class="btn btn-default">취소</button>
			<button type="submit" class="btn btn-default" data-oper="list">목록</button>
			
		</form>
	</div>

<script>
$(document).ready(function(e){
	
	var formObj = $("form[role='form']");
	
	$("button[data-oper='register']").on("click", function(e){
		
		e.preventDefault();
		console.log("submit clicked");
		
		var str = "";
		
		$(".uploadResult ul li").each(function(i, obj){
			var jobj = $(obj);
			
			str +="<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
			str +="<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
			str +="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
			str +="<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
		
		});
		
		formObj.append(str).submit();
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
	
	$(".uploadResult").on("click", "button", function(e){
		
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
	});
	
	$("button[data-oper='list']").on("click", function(e){
		
		formObj.attr("action", "/movie/list").attr("method", "get");
		formObj.submit();
	});
	
});

</script>  


<%@ include file="../includes/footer.jsp" %>