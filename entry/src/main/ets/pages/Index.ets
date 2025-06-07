import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import { taskpool } from '@kit.ArkTS';

const DOMAIN = 0x0000;

@Concurrent
function worker() {
  return testNapi.read();
}

testNapi.run();

@Entry
@Component
struct Index {
  @State message: string = "";
  @State input: string = "";
  scroller: Scroller = new Scroller();

  onPageShow() {
    (async () => {
      let task: taskpool.Task = new taskpool.Task(worker);
      while(1) {
        let content: string = await taskpool.execute(task) as string;
        if (content === undefined) {
          break;
        }
        this.message += content;
        this.scroller.scrollEdge(Edge.Bottom);
      }
    })();
  }

  build() {
    Row() {
      Column() {
        Scroll(this.scroller) {
          Text(this.message)
            .align(Alignment.Top)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
            .width("100%")
        }
        .align(Alignment.Top)
        .height("90%")
        Row() {
          TextInput({ text: this.input })
            .onChange((value: string) => {
              this.input = value;
              console.info(value);
            })
            .onSubmit(() => {
              testNapi.send(this.input + "\n");
              this.input = "";
              focusControl.requestFocus("input");
            })
            .id("input")
            .width("70%")
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}
