abstract class Mapper<I, O> {
  O mapFrom(I input);
  I mapTo(O output);
}
