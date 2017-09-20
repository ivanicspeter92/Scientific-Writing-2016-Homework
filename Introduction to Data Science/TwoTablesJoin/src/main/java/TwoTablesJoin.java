import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.ObjectWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;

public class TwoTablesJoin {
    public static class StudentScoreMapper extends Mapper<Object, Text, Text, ObjectWritable>{
        private final static ObjectWritable result = new ObjectWritable();

        public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
            String filename = ((FileSplit) context.getInputSplit()).getPath().getName();
            String line = value.toString();
            String[] components = line.split(",");

            if (filename.contains("student")) {
                String id = components[0], name = components[1];
                int year = Integer.parseInt(components[2]);

                if(year > 1990) {
                    result.set(new Student(id, name, year));

                    context.write(new Text(id), result);
                    System.out.println("Wrote student " + id);
                }
            } else if (filename.contains("score")){
                String id = components[0];
                int score1 = Integer.parseInt(components[1]), score2 = Integer.parseInt(components[2]), score3 = Integer.parseInt(components[3]);

                if(score1 > 80 && score2 <= 95) {
                    result.set(new Score(id, score1, score2, score3));

                    context.write(new Text(id), result);
                    System.out.println("Wrote score " + id);
                }
            } else {
                System.out.println("Unsupported file");
            }
        }
    }

    public static class TableJoinReducer extends Reducer<Text, ObjectWritable, Text, ObjectWritable> {
        private Text result = new Text();

        public void reduce(Text key, Iterable<ObjectWritable> values, Context context) throws IOException, InterruptedException {
            String combinedTables = "";

            //context.write(key, combinedTables);
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "two tables join");
        job.setJarByClass(TwoTablesJoin.class);
        job.setMapperClass(StudentScoreMapper.class);
        job.setCombinerClass(TableJoinReducer.class);
        job.setReducerClass(TableJoinReducer.class);

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(ObjectWritable.class);

        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }

    public static class Student extends Object {
        String id, name;
        int year;

        public Student(String id, String name, int year) {
            this.id = id;
            this.name = name;
            this.year = year;
        }
    }

    public static class Score extends Object {
        String studentID;
        int score1, score2, score3;

        public Score(String studentID, int score1, int score2, int score3) {
            this.studentID = studentID;
            this.score1 = score1;
            this.score2 = score2;
            this.score3 = score3;
        }
    }
}