import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import { taskpool } from '@kit.ArkTS';

const DOMAIN = 0x0000;

@Concurrent
function worker() {
  return testNapi.read();
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World:';

  onPageShow() {
    testNapi.run();
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            let task: taskpool.Task = new taskpool.Task(worker);
            while(1) {
              let content: string = await taskpool.execute(task) as string;
              if (content === undefined) {
                break;
              }
              this.message += content;
            }
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
