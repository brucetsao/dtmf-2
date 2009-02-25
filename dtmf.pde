// References
//========DTMGF table========
//     1209 	1336  	1477   1633
//697  1        2       3      A
//770  4        5 	6      B
//852  7        8  	9      C
//941  * 	0 	#      D
//============================
//http://www.ocf.berkeley.edu/~fricke/dtmf.html
//http://en.wikipedia.org/wiki/Dtmf
//http://www.itu.int/rec/dologin_pub.asp?lang=e&id=T-REC-F.902-199502-I!!PDF-E&type=items


#define PIN_ROW 9

#define MAX_BINS 4      

static double pi = 3.14159;
double samprate = 8000.0;      /* 8000 samples per second */


int      freqs_row[ MAX_BINS] = 
{
  697,
  770,
  852,
  941
};
int      freqs_col[MAX_BINS] =
{
  1209,
  1336,
  1477,
  1633 
};

char  row_col_ascii_codes[MAX_BINS][MAX_BINS] = {
  { '1','2','3','A'  },
  { '4','5','6','B'  },
  { '7','8','9','C'  },
  { '*','0','#','D'  }};

int row_col[2];

// type
struct retarr {
  int row_col[2];
};

void setup()
{
  Serial.begin(9600);
 // pinMode(PIN_ROW, OUTPUT);
 // pinMode(PIN_COL, OUTPUT);
}

int write_signal(int col_freq, int row_freq, int length) {
  int tone_length=1;
  unsigned int sample;
  while (tone_length<length) {
/*    sample = (unsigned char)(128.0 + 64.0*cos(2*pi*col_freq*tone_length) 
                                + 64.0*cos(2*pi*row_freq*tone_length));*/
    sample = ( cos( 2*pi*col_freq*tone_length ) + cos( 2*pi*row_freq*tone_length ) );
    analogWrite(PIN_ROW, sample);
    tone_length += 1.0; /* increment time */
  }
  return(0);
}


struct retarr keytofreq(char key)
{
  // variable
  struct retarr var_row_col;

  for (int row=0;row<MAX_BINS;row++) {
    for (int col=0;col<MAX_BINS;col++) {
      if (key==row_col_ascii_codes[row][col]) {
        var_row_col.row_col[0] =  freqs_row[row];
        var_row_col.row_col[1] =  freqs_col[col];
        return var_row_col;
      }
    }
  }
}
/*
int freqtoperiod (int freq) {
  analogWrite(PIN_ROW, 75);
  int period;
  return period;
}
*/


void loop()
{
 // analogWrite(PIN_ROW, 20);
 // analogWrite(PIN_COL, 200);
 
  struct retarr pfreq1 = keytofreq('1');
  struct retarr pfreq2 = keytofreq('2');
  struct retarr pfreq3 = keytofreq('3');
  Serial.println("Tone 1:");
  write_signal(pfreq1.row_col[0],pfreq1.row_col[1],10000);
  delay(1000);
  
  Serial.println("Tone 2:");
  write_signal(pfreq2.row_col[0],pfreq1.row_col[1],10000);
  delay(1000);
  
  Serial.println("Tone 3:");
  write_signal(pfreq3.row_col[0],pfreq1.row_col[1],10000);
  delay(1000);
  //Serial.println(pfreq1.row_col[0]);
  //Serial.println(pfreq1.row_col[1]);
  
  
    //analogWrite(PIN_ROW, 254);
  delay(500);
}
