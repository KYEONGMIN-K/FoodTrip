var btn = document.querySelector(".overlap");
console.log(btn);
var submitBtn = document.querySelector("input[type='submit']");
submitBtn.disabled=true; // 초기 상태에서 회원가입 버튼 비활성화
var isNickNameValid = false; // 닉네임 유효 여부
btn.addEventListener("click", overlap);

function overlap(){
	console.log("중복확인 실행");
	var inputdata = document.querySelector("#nickName").value;
	console.log(inputdata);
	$.ajax({
		url : "overlap",
		type : "post",
		data : JSON.stringify({nickName : inputdata}),
		contentType : "application/json",
		success : function(data){
			console.log(data);
			if(data==true){
					alert("존재하는 닉네임 입니다.");
					isNickNameValid = false;
					submitBtn.disabled = true; // 존재하는 경우 버튼 비활성화
			} else {
				alert("사용가능한 닉네임 입니다.");		
				isNickNameValid = true;
				submitBtn.disabled = false; // 사용 가능하면 버튼 활성화		
			 }
		},
		error : function(errorThrown){

		}
	})
}