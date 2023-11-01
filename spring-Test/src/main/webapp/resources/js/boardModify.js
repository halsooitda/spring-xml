document.addEventListener('click',(e)=>{
    if(e.target.classList.contains('file-x')){
        console.log("삭제 버튼 클릭!");
        let uuid = e.target.dataset.uuid;

        removeFileToServer(uuid).then(result=>{
            if(result == 1){
                alert('파일 삭제 성공');
                e.target.closest('li').remove(); //li삭제
                location.reload(); //새로고침
            }else{
                alert('파일 삭제 실패');
            }
        })
    }
})

async function removeFileToServer(uuid){
    try{
        const url = '/board/file/'+uuid;
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