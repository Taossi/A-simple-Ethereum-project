pragma solidity^0.5.1;

contract Match{
    struct Producer{
        uint quote;
        uint Producecharge;
    }
    struct Consumer{
        uint quote;
        uint Demandcharge;
    }
    
    Producer P1 = Producer(65,15);    Consumer C1 = Consumer(75,15);
    Producer P2 = Producer(68,15);    Consumer C2 = Consumer(70,10);
    Producer P3 = Producer(60,10);    Consumer C3 = Consumer(80,20);   
    Producer P4 = Producer(75,30);    Consumer C4 = Consumer(90,15); 
    Producer P5 = Producer(71,20);    Consumer C5 = Consumer(85,20);
  
    
    uint[] PArray1 = [P1.quote,P2.quote,P3.quote,P4.quote,P5.quote];
    uint[] PArray2 = [P1.Producecharge,P2.Producecharge,P3.Producecharge,P4.Producecharge,P5.Producecharge];
    uint[] CArray1 = [C1.quote,C2.quote,C3.quote,C4.quote,C5.quote];
    uint[] CArray2 = [C1.Demandcharge,C2.Demandcharge,C3.Demandcharge,C4.Demandcharge,C5.Demandcharge];
    
    
    uint[]  DealPrice=[0,0,0,0,0,0,0,0,0,0];
    uint[]  DealCharge=[0,0,0,0,0,0,0,0,0,0];
    
    
    function getContent1() public view returns(uint[] memory){
        
        return  PArray1;
    }
    function getContent2() public view returns(uint[] memory){
        
        return  CArray1;
    }
    
    function SortP()public  returns(uint[] memory) {
        
        for (uint i = 0; i < PArray1.length; i++) {
            for (uint j = 0; j < PArray1.length - i -1; j++) {   
                if (PArray1[j] > PArray1[j + 1]) {
                    uint temp = PArray1[j];
                    uint temp2 = PArray2[j];
                    PArray1[j] = PArray1[j + 1];
                    PArray2[j] = PArray2[j + 1];
                    PArray1[j + 1] = temp;
                    PArray2[j + 1] = temp2;
                }
            }
        }
        return PArray1;
    }

    function SortC()public returns(uint[] memory) {
        
        for (uint i = 0; i < CArray1.length; i++) {
            for (uint j = 0; j < CArray1.length - i -1; j++) {   
                if (CArray1[j] < CArray1[j + 1]) {
                    uint temp = CArray1[j];
                    uint temp2 = CArray2[j];
                    CArray1[j] = CArray1[j + 1];
                    CArray2[j] = CArray2[j + 1];
                    CArray1[j + 1] = temp;
                    CArray2[j + 1] = temp2;
                }
            }
        }
        return CArray1;
    }
    
    function getContent3() public view returns(uint[] memory){
        return  PArray2;
    }
    function getContent4() public view  returns(uint[] memory){
        return  CArray2;
    }
}


contract map is Match{
    
    mapping (address=>uint) public a;
    
    constructor() public {
    }
    
    address[] p =[0xDb7eab16314B7EF413B566EF404a41b66cB485cc,0x71E3970eDA7B3ba876973a0DD1dE817D0e68D352,0xEb06B40478853Eb3aB2677FEFebeDB6Ef6bd96e6,0x2c263a5613Ec8482a60D595f419F159d8D9785bB,0x57F9d0fF64Db9319a551fAb18eCd219151F39Af1];
    address[] c =[0xF81A7e5722A96340118d68de97255Fd7de13De9b,0xa39416ed4F4d5D876578eB2820928C0D428B35Fe,0xDB71a1d48a732Efb951223bD0555996b8EFA828f,0x79a7fA7f979447C7a810df8de78e80e0E1C0Cb3F,0x976B4ad13E9c810fA3CdA440EF87F8Dd37A64A61]; 
        
    uint[] pp=[0,0,0,0,0];
    uint[] cc=[0,0,0,0,0];
    
    // 1 eth=1500 rmb
    function mapp() public{
        for(uint i=0;i<p.length;++i){
            a[p[i]]=1*1500;
        }
    }
    
    function mapc() public{
        for(uint i=0;i<p.length;++i){
            a[c[i]]=1*1500;
        }
    }
    
    function add (address _a,uint b) public{
        a[_a]+=b;
    }
    
    function min (address _a,uint b) public{
        a[_a]-=b;
    }

    
    function modify() public {
        for(uint i=0;i<p.length;++i){
            pp[i]=a[p[i]];
        }
        for(uint j=0;j<c.length;++j){
            cc[j]=a[c[j]];
        }
    }
    
    function showp()public view  returns(uint [] memory){
        return pp;
    }
    function showc()public view  returns(uint [] memory){
        return cc;
    }
    
}

contract Match2 is Match,map{
     uint deal;
     uint [] dealprice;
     uint [] dealcharge;
     
    function MatchPC()public returns(uint, uint[] memory) {
        SortC();
        SortP();
        uint  Deals = 0;
        for(uint i = 0;i < PArray1.length;i++){
            for(uint j = 0;j < CArray1.length;j++){
                if((PArray1[i] <= CArray1[j])&&(PArray2[i]!=0)&&(CArray2[j]!=0)){
                    if(PArray2[i]<=CArray2[j]){
                        DealPrice[Deals]=PArray2[i];
                        DealCharge[Deals]=(PArray1[i]+CArray1[j])/2;
                        add(p[i],DealPrice[Deals]*DealCharge[Deals]/100);
                        min(c[j],DealPrice[Deals]*DealCharge[Deals]/100);
                        Deals++;
                        CArray2[j]-=PArray2[i];
                        PArray2[i]=0;
                        break;
                    }
                    else{
                        DealPrice[Deals]=CArray2[j];
                        DealCharge[Deals]=(PArray1[i]+CArray1[j])/2;
                        add(p[i],DealPrice[Deals]*DealCharge[Deals]/100);
                        min(c[j],DealPrice[Deals]*DealCharge[Deals]/100);
                        Deals++;
                        PArray2[i]-=CArray2[j];
                        CArray2[j]=0;
                        continue;
                        
                    }
                    
                    }
                }
            }
            deal=Deals;
            dealprice=DealPrice;
            dealcharge=DealCharge;
            return (Deals,DealPrice);
        }
  
  
    function getdeal() public view returns(uint){
        return deal;
    }
    
    function getdealcharge() public view returns(uint [] memory){
        return dealprice;
    }
    
    function getdealprice() public view returns(uint [] memory){
        return dealcharge;
    }
    
}
