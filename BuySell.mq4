//+------------------------------------------------------------------+
//|                                    BuySell.mq4|
//|                                         Developed by Boutiti Nizar |
//|                                     |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2015, Boutiti Nizar"
#property link      " "
 
 
extern bool buyorder              = FALSE;
extern bool sellorder             = FALSE;
extern double Lots                = 1;
extern int   Total_StopLoss       =   100000;


////////////////////////////////////////////////////////
int MagicNumber                   = 999;
int MaxORders                     = 20;
string TradeComment               ="Boutiti Nizar EA 2014";
int Slippage                      =2;
double Poin;
bool stop = false;



//+------------------------------------------------------------------+
//| Custom initialization function                                   |
//+------------------------------------------------------------------+
int init(){

   if (Point == 0.00001) Poin = 0.0001;
   else {
      if (Point == 0.001) Poin = 0.01;
      else Poin = Point;
   }
   
    go();
   return(0);
}
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start(){



double gettotalprofite = gettotalprofite();
 
if(gettotalprofite > 0 && gettotalprofite >= Total_TakeProfit ){
   CloseDeleteAll();
   stop = true;
}

if(gettotalprofite < 0 && gettotalprofite >= Total_StopLoss ){
  CloseDeleteAll();
   stop = true;
  
}


 if(stop == 0){
   go();
 }





// } 
}


double gettotalprofite(){
 double Profit = 0; 
  for(int cnt = 0; cnt < OrdersTotal(); cnt ++)   
   {
      if (!OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)) continue;    
      Profit += OrderProfit();
   }
   
   return Profit;
}


bool CloseDeleteAll()
{
    int total  = OrdersTotal();
      for (int cnt = total-1 ; cnt >=0 ; cnt--)
      {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);

         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) 
         {
            switch(OrderType())
            {
               case OP_BUY       :
               {
                  if(!OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),Slippage,Violet))
                     return(false);
               }break;                  
               case OP_SELL      :
               {
                  if(!OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),Slippage,Violet))
                     return(false);
               }break;
            }             
         
            
            if(OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP || OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT)
               if(!OrderDelete(OrderTicket()))
               { 
                  Print("Error deleting " + OrderType() + " order : ",GetLastError());
                  return (false);
               }
          }
      }
      return (true);
}


bool go(){
//BUY

int ticket;
int c,x,err;
int NumberOfTries=5;
       if(buyorder == TRUE ){  
       
      for(x=0;x<MaxORders;x++){
      for(c=0;c<NumberOfTries;c++){
      RefreshRates();
       
       ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,TradeComment,MagicNumber,0,Blue);
         err=GetLastError();
      
       
       if(err==0){break;}
      else{
          Print("Errors opening BUY order err:"+err);
           if(err==4 || err==137 ||err==146 || err==136){
           Sleep(100);continue;//Busy errors
           }
           else{break;}//normal error
           
      }
      
      }//for error/NumberOfTries
      }
      
       
      
      }
      
      
      //sell
         else if(sellorder == TRUE  ){ 
         
         for(x=0;x<MaxORders;x++){
         for(c=0;c<NumberOfTries;c++){
         RefreshRates();
          
          ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,TradeComment,MagicNumber,0,Red);
         
            err=GetLastError();
          
            if(err==0){break;}
         else{
             Print("Errors opening SELL order err:"+err);
              if(err==4 || err==137 ||err==146 || err==136){
              Sleep(100);continue;//Busy errors
              }
              else{break;}//normal error     
         }
         } 
         }
 
}
}