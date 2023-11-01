console.log(bnoVal);

//1
async function postCommentToServer(cmtData){
    try{
        const url = "/comment/post";
        const config = {
            method : "post",
            headers : {
                'content-type' : 'application/json; charset=utf-8'
            },
            body : JSON.stringify(cmtData)
        };

        const resp = await fetch(url, config);
        const result = await resp.text(); //isOk
        return result;

    }catch(err){
        console.log(err);
    }
}

//2
document.getElementById('cmtPostBtn').addEventListener('click',()=>{
    const cmtText = document.getElementById('cmtText').value;
    const cmtWriter = document.getElementById('cmtWriter').innerText; //span안에 있는 값을 가져올 때
    if(cmtText == "" || cmtText == null){
        alert("댓글을 입력해주세요.");
        document.getElementById('cmtText').focus();
        return false;
    }else {
        let cmtData = {
            bno : bnoVal,
            writer : cmtWriter,
            content : cmtText
        };
        console.log(cmtData);
        postCommentToServer(cmtData).then(result => {
            console.log(result);
            //isOk 확인
            if(result == 1){
                alert("댓글 등록 성공");
                //화면에 뿌리기
                //5
                getCommentList(bnoVal);
            }
        })
    }
})

//3
async function spreadCommentListFromServer(bno){
    try{
        const resp = await fetch('/comment/'+bno);
        const result = await resp.json();
        return result;

    }catch(err){
        console.log(err);
    }
}

//4
function getCommentList(bno){
    spreadCommentListFromServer(bno).then(result => {
        console.log(result);
        //화면에 뿌리기
        const ul = document.getElementById("cmtListArea"); //댓글 영역을 감싸는 ul
        if(result.length > 0){
            ul.innerHTML = ""; //jsp에 임시로 넣어둔 댓글 표시영역을 지우고, 비어있는 값으로 바꿔버리기
            // {[], [], []} 형태로 데이터가 들어옴 
            for(let cvo of result){
                let str = `<li data-cno="${cvo.cno}">`;
                //li에 data-writer=${cvo.writer}
                str += `<div>`;
                str += `<div>${cvo.writer}</div>`;
                str += `<input type="text" id="cmtTextMod" value="${cvo.content}">`;
                str += `</div>`;
                str += `<span>${cvo.reg_date}</span>`;
                if(cvo.writer == id){
                    str += `<button type="button" class="modBtn">%</button>`;
                    str += `<button type="button" class="delBtn">X</button>`;
                }
                str += `</li>`;
                
                ul.innerHTML += str;
            }
        }else{
            let str = `<li>Commnet List Empty</li>`;
            ul.innerHTML = str;
        }

    })
}

//6
async function editCommentToServer(cmtModData){
    try{
        const url = '/comment/'+cmtModData.cno;
        const config = {
            method : 'put', //수정할 때 사용하는 메서드
            headers : {
                'content-type' : 'application/json; charset=utf-8'
            },
            body : JSON.stringify(cmtModData)
        };

        const resp = await fetch(url, config);
        const result = await resp.text();
        return result; 
        
    }catch(err){
        console.log(err);
    }
}

//7
async function removeCommentToServer(cno){
    try{
        const url = '/comment/'+cno; 
        const config = {
            method : 'delete'
        };
        const resp = await fetch(url, config);
        const result = await resp.text();
        return result;

    }catch(err){
        console.log(err);
    }
}

//8
document.addEventListener('click',(e)=>{
    console.log(e.target);
    if(e.target.classList.contains('modBtn')){
        //수정작업
        console.log('수정버튼 클릭~!!');
        //내가 선택한 타겟과 가장 가까운 li 찾기
        let li = e.target.closest('li');
        let cnoVal = li.dataset.cno;
        //let writerVal = li.dataset.writer;
        let textContent = li.querySelector('#cmtTextMod').value;
        console.log("cno / content >>> "+cnoVal+" / "+textContent);

        let cmtModData = {
            cno : cnoVal, //이름 같으면 에러남
            //writer : writerVal,
            content : textContent
        };
        console.log(cmtModData);

        //서버연결
        editCommentToServer(cmtModData).then(result =>{
            if(result == 1){
                alert('댓글 수정 성공~!!');
            }
            getCommentList(bnoVal); //수정 후 반영된 것 띄워주기
        })

    }else if(e.target.classList.contains('delBtn')){
        //삭제작업
        console.log('삭제버튼 클릭~!!');
        let li = e.target.closest('li');
        let cnoVal = li.dataset.cno;

        //서버연결
        removeCommentToServer(cnoVal).then(result =>{
            if(result == 1){
                alert('댓글 삭제 성공!');
            }
            getCommentList(bnoVal);
        })
    }
})